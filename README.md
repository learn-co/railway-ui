# Railway UI

The UI layer for the [Railway IPC package](https://github.com/learn-co/railway_ipc).

## Installation

Include the Railway UI package in your `mix.exs` file:

```elixir
def deps do
  [
    {:railway_ui, "~> 0.0.6"}
  ]
end
```

## Getting Started

The router plug can be mounted inside the Phoenix router with Phoenix.Router.forward/4.

```elixir
defmodule MyPhoenixApp.Web.Router do
  use MyPhoenixApp.Web, :router

  pipeline :mounted_apps do
    plug :accepts, ["html"]
    plug :put_secure_browser_headers
  end

  scope path: "/railway-ipc" do
    pipe_through :mounted_apps
    forward "/", RailwayUiWeb.Router, namespace: "railway-ipc"
  end
end
```

**Note:** There is no need to add `:protect_from_forgery` to the `:mounted_apps` pipeline because this package already implements CSRF protection. In order to enable it, your host application must use the Plug.Session plug, which is usually configured in the endpoint module in Phoenix.

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm).
Once published, the docs can
be found at [https://hexdocs.pm/railway_ipc](https://hexdocs.pm/railway-ui).
