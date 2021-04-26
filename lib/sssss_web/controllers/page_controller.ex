defmodule SssssWeb.PageController do
  use SssssWeb, :controller
  alias Sssss.GrabScreenshot

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def takeshot(conn, %{"url" => url}) do
    GrabScreenshot.run(url)
    json(conn, %{url: url})
  end
end
