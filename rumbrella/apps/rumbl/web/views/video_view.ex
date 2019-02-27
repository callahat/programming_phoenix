defmodule Rumbl.VideoView do
  use Rumbl.Web, :view

  def category_name(video) do
    if video.category_id do
      video.category.name
    else
     "N/A"
    end
  end
end
