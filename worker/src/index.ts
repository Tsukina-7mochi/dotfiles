const STATIC_ROOT = new URL(
  "https://raw.githubusercontent.com/Tsukina-7mochi/dotfiles/refs/heads/main/",
);

export default {
  async fetch(
    request: Request,
    _env: unknown,
    _ctx: unknown,
  ): Promise<Response> {
    const pathname = new URL(request.url).pathname;
    const proxyRequest = new Request(new URL(`./${pathname}`, STATIC_ROOT));

    return await fetch(proxyRequest);
  },
};
