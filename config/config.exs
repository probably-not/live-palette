import Config

if Mix.env() == :dev do
  esbuild = fn args ->
    [
      args: ~w(./js/live_palette --bundle) ++ args,
      cd: Path.expand("../assets", __DIR__),
      env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
    ]
  end

  config :esbuild,
    version: "0.25.10",
    module: esbuild.(~w(--format=esm --sourcemap --outfile=../priv/static/js/live_palette.esm.js)),
    main: esbuild.(~w(--format=cjs --sourcemap --outfile=../priv/static/js/live_palette.cjs.js))
end
