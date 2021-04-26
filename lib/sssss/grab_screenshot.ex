defmodule Sssss.GrabScreenshot do
  import Ecto

  alias Sssss.Screenshots


  def run(site, table) do
    uuid = Ecto.UUID.generate
    get_site_height(site, uuid, table)
    [{_, height}] = :ets.lookup(table, uuid)
    take_screen_shot(uuid, height, site)
    store_image(uuid)
    path = "#{System.get_env("IMG_PATH")}/#{uuid}.png"
    {path, height}
  end

    defp get_site_height(site, uuid, table) do
    {:ok, session} = Wallaby.start_session()

    session
    |> Wallaby.Browser.visit(site)
    |> Wallaby.Browser.execute_script(
         "return Math.max(
    document.body.scrollHeight,
    document.documentElement.scrollHeight,
    document.body.offsetHeight,
    document.documentElement.offsetHeight,
    document.documentElement.clientHeight
  ); ",
         [],
         fn height -> :ets.insert(table, {uuid, height}) end
       )
    |> Wallaby.end_session()

  end

  def take_screen_shot(uuid, height, site) do
    {:ok, session} = Wallaby.start_session(
      window_size: [
        width: 1280,
        height: height
      ]
    )
    session
    |> Wallaby.Browser.visit(site)
    |> Wallaby.Browser.take_screenshot([{:name, "#{uuid}"}])
    |> Wallaby.end_session()
  end

  def store_image(uuid) do
    dest = Path.join("screenshots", "#{uuid}.png")
    Screenshots.store(dest)
  end

end