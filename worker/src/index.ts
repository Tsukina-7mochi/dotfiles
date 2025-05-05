// deno-fmt-ignore
const REPO_URL = new URL("https://github.com/Tsukina-7mochi/dotfiles");

// deno-fmt-ignore
const STATIC_ROOT = new URL("https://raw.githubusercontent.com/Tsukina-7mochi/dotfiles/refs/heads/main/");

export default {
  async fetch(
    request: Request,
    _env: unknown,
    _ctx: unknown,
  ): Promise<Response> {
    const pathname = new URL(request.url).pathname;

    if (pathname === "/") {
      return Response.redirect(REPO_URL, 302);
    }

    const redirectUrl = new URL(`./${pathname}`, STATIC_ROOT);
    return Response.redirect(redirectUrl, 302);
  },
};
