defmodule LivePaletteDemoWeb.HomeLive do
  use LivePaletteDemoWeb, :live_view

  import LivePalette

  def mount(_params, _session, socket) do
    actions = [
      %LivePaletteDemoWeb.GotoExternal{
        title: "Go to Google",
        link: "https://www.google.com"
      },
      %LivePaletteDemoWeb.GotoExternal{
        title: "Go to GitHub",
        subtitle: "This does something else",
        link: "https://www.github.com"
      },
      %LivePaletteDemoWeb.GotoExternal{
        title: "Go to the live_palette Docs",
        link: "https://hexdocs.pm/live_palette/"
      },
      %LivePaletteDemoWeb.GotoInternal{
        title: "Home",
        link: ~p"/"
      },
      %LivePaletteDemoWeb.RenderedAction{
        title: "Show a modal",
        subtitle: "This action shows a random modal to see how rendered actions work",
        icon_name: "hero-sparkles",
        always_show?: false
      }
    ]

    {:ok, assign(socket, actions: actions)}
  end

  def render(assigns) do
    ~H"""
    <.live_palette id="example" require_metakey={true} actions={@actions} />
    <div class="max-w-4xl mx-auto px-4 py-12">
      <h1 class="text-3xl font-bold text-center mb-8">
        LivePalette
      </h1>
      <p class="text-lg mb-6">
        <span class="underline">LivePalette</span> is a command palette for Phoenix LiveView,
        reminiscent of the VSCode and Sublime Command Palettes,
        the macOS Spotlight and Alfred, and Linear's Command-K Command Bar.
      </p>
      <p class="mb-8">
        See it in action here! Press <kbd class="px-2 py-1 bg-gray-100 rounded">cmd + k</kbd>
        (on macOS) or <kbd class="px-2 py-1 bg-gray-100 rounded">ctrl + k</kbd>
        (on Linux/Windows) to see it in action.
      </p>

      <h2 class="text-2xl font-bold mb-4">Docs and Usage</h2>
      <p class="mb-8">
        You can find usage information and documentation on Hexdocs at the following link:
        <a href="https://hexdocs.pm/live_palette" class="text-gray-600 hover:text-gray-900 underline">
          https://hexdocs.pm/live_palette
        </a>
      </p>
    </div>
    """
  end
end
