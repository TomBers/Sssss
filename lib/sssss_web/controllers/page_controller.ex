defmodule SssssWeb.PageController do
  use SssssWeb, :controller
  alias Sssss.GrabScreenshot

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def takeshot(conn, %{"url" => url}) do
    table = :ets.new(:site_cache, [:set, :protected])
    {path, height} = GrabScreenshot.run(url, table)
    json(conn, %{path: path, width: 1280, height: height})
  end
end
