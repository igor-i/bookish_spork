defmodule ChuckNorrisApiTest do
  use ExUnit.Case
  doctest ChuckNorrisApi

  setup_all do
    {:ok, _} = :bookish_spork.start_server
    {:ok, %{}}
  end

  test "retrieves random joke" do
    :bookish_spork.stub_request([200, %{}, "{
      \"value\": \"Chuck norris tried to crank that soulja boy but it wouldn't crank up\"
    }"])
    assert ChuckNorrisApi.random == "Chuck norris tried to crank that soulja boy but it wouldn't crank up"

    {:ok, request} = :bookish_spork.capture_request
    assert request.uri == '/jokes/random'
  end

  test "retrieves a random joke from a particular category" do
    :bookish_spork.stub_request([200, %{}, "{
      \"value\": \"Chuck Norris doesn't go on the internet, he has every internet site stored in his memory. He refreshes webpages by blinking.\"
    }"])
    assert ChuckNorrisApi.random("dev") == "Chuck Norris doesn't go on the internet, he has every internet site stored in his memory. He refreshes webpages by blinking."

    {:ok, request} = :bookish_spork.capture_request
    assert request.uri == '/jokes/random?category=dev'
  end

  test "retrieves two random jokes in different processes" do
    :bookish_spork.stub_request([200, %{}, "{\"value\": \"First joke.\"}"])
    :bookish_spork.stub_request([200, %{}, "{\"value\": \"Second joke.\"}"])

    Task.start(fn -> ChuckNorrisApi.random() end)
    Task.start(fn -> ChuckNorrisApi.random() end)

    Process.sleep(500)

    {:ok, _request} = :bookish_spork.capture_request()
    {:ok, _request} = :bookish_spork.capture_request()
    {:error, _request} = :bookish_spork.capture_request()
  end
end
