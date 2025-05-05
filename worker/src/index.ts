// deno-fmt-ignore
const REPO_URL = new URL("https://github.com/Tsukina-7mochi/dotfiles");

// deno-fmt-ignore
const contentUrl = (ref = "main") =>
  new URL(`https://raw.githubusercontent.com/Tsukina-7mochi/dotfiles/refs/heads/${ref}/`);

export default {
  async fetch(
    request: Request,
    _env: unknown,
    _ctx: unknown,
  ): Promise<Response> {
    const url = new URL(request.url);
    const pathname = url.pathname;
    const searchParams = url.searchParams;

    if (pathname === "/") {
      return Response.redirect(REPO_URL, 302);
    }

    const ref = searchParams.get("ref") ?? undefined;
    const redirectUrl = new URL(`.${pathname}`, contentUrl(ref));
    return Response.redirect(redirectUrl, 302);
  },
};
