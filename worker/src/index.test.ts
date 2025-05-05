import { assertEquals } from "@std/assert";
import index from "./index.ts";

const { fetch } = index;

Deno.test("Root path", async () => {
  const req = new Request("https://dotfiles.ts7m.net/");

  const res = await fetch(req, null, null);

  assertEquals(res.status, 302);
  assertEquals(
    res.headers.get("Location"),
    "https://github.com/Tsukina-7mochi/dotfiles",
  );
});

Deno.test("Normal path", async () => {
  const req = new Request("https://dotfiles.ts7m.net/foo/bar.txt");

  const res = await fetch(req, null, null);

  assertEquals(res.status, 302);
  assertEquals(
    res.headers.get("Location"),
    "https://raw.githubusercontent.com/Tsukina-7mochi/dotfiles/refs/heads/main/foo/bar.txt",
  );
});

Deno.test("With ref", async () => {
  const req = new Request("https://dotfiles.ts7m.net/foo/bar.txt?ref=dev");

  const res = await fetch(req, null, null);

  assertEquals(res.status, 302);
  assertEquals(
    res.headers.get("Location"),
    "https://raw.githubusercontent.com/Tsukina-7mochi/dotfiles/refs/heads/dev/foo/bar.txt",
  );
});
