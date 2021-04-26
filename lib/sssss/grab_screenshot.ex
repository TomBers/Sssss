defmodule Sssss.GrabScreenshot do
  import Ecto

  alias Sssss.Screenshots

  def run(site) do
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
         fn height -> take_screen_shot(height, site) end
       )
    |> Wallaby.end_session()

  end

  def take_screen_shot(height, site) do
    uuid = Ecto.UUID.generate
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

    store_image(uuid)
  end

  def store_image(uuid) do
    dest = Path.join("screenshots", "#{uuid}.png")
    Screenshots.store(dest)
  end

end