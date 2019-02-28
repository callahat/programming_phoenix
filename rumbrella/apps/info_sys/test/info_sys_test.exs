defmodule InfoSysTest do
  use ExUnit.Case
  doctest InfoSys
  alias InfoSys.Result

  defmodule TestBackend do
    def start_link(query, query_ref, owner, limit) do
      Task.start_link(__MODULE__, :fetch, [query, query_ref, owner, limit])
    end
    def fetch("result", query_ref, owner, _limit) do
      send(owner, {:results, query_ref, [%Result{backend: "test", text: "test result"}]})
    end
    def fetch("none", query_ref, owner, _limit) do
      send(owner, {:results, query_ref, []})
    end
    def fetch("timeout", _query_ref, owner, _limit) do
      send(owner, {:backend, self()})
      :timer.sleep(:infinity)
    end
    def fetch("crash", _query_ref, _owner, _limit) do
      raise "OUCH"
    end
  end

  test "compute/2 with backend results" do
    assert [%Result{backend: "test", text: "test result"}] =
           InfoSys.compute("result", backends: [TestBackend])
  end

  test "compute/2 with no backend results" do
    assert [] =
           InfoSys.compute("none", backends: [TestBackend])
  end

  test "compute/2 with timeout returns no results and kills workers" do
    results = InfoSys.compute("timeout", backends: [TestBackend], timeout: 10)
    assert [] = results
    assert_receive {:backend, backend_pid}
    ref = Process.monitor(backend_pid)
    assert_receive {:DOWN, ^ref, :process, _pid, _reason}
    refute_received {:DOWN, _, _, _, _}
    refute_received :timeout
  end

  @tag :capture_log
  test "compute/2 with crash returns no results and kills workers" do
    results = InfoSys.compute("crash", backends: [TestBackend])
    assert [] = results
    refute_received {:DOWN, _, _, _, _}
    refute_received :timeout
  end
end
