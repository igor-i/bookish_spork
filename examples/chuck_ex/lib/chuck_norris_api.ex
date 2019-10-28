defmodule ChuckNorrisApi do
  def random(category \\ nil)

  def random(category) when is_nil(category) do
    request("#{url()}/random")
  end

  def random(category) do
    request("#{url()}/random?category=#{category}")
  end

  defp request(url) do
    HTTPoison.get!(url, [{"Connection", "close"}]).body |> Poison.decode! |> Map.fetch!("value")
    # HTTPoison.get!(url).body |> IO.inspect |> Poison.decode! |> IO.inspect |> Map.fetch!("value")
  end

  defp url do
    "#{proto()}://#{host()}/jokes"
  end

  defp host do
    Application.fetch_env!(:chuck_norris_api, :host)
  end

  defp proto do
    Application.fetch_env!(:chuck_norris_api, :proto)
  end
end
