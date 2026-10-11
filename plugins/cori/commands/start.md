---
description: Take a first Cori app to its preview URL — the cori command line, a sign-in, an app from the starter template, a first release
---

# Start with Cori

Take the user from nothing to a first Cori app they can open in their browser, in the order below. Say in one line what
you are doing at each step. When a step fails, show its error and what to do, and stop there.

The app id is the one the user gave with the command (`$ARGUMENTS`), else `my-team`: letters, digits, `-` and `_` (it
becomes part of the app's URL).

1. **The Cori MCP server.** This plugin adds it (`cori`, at https://app.cori.do/mcp). Call its `list_apps` tool. If the
   tools are missing or the server says authentication is needed, ask the user to run `/mcp`, choose `cori` and sign in:
   their browser opens on Cori's sign-in page, where a new user can create an account. Then call `list_apps` again.
   Never ask for a password or a token in the conversation.
2. **The command line.** Run `cori --version`. If `cori` is missing, install it with `npm install -g @cori-do/cli`
   (macOS and Linux; Windows through WSL). Where a global install is not possible, write `npx @cori-do/cli` wherever
   the steps below say `cori`.
3. **The app.** Call `create_app` with `{"id": "<app id>", "template": "team-requests"}`. If the id is taken, choose
   another one (`list_apps` shows the user's apps) or ask the user.
4. **A session for the command line.** Call `login` with `{"app": "<app id>"}`. In the current folder (or the one the
   user named), run the `bootstrap` command it returns, as it is: it writes the folder `<app id>/` from the template,
   with the session in `<app id>/.cori/session`. The session is short-lived and limited to this app; when a later
   command says it expired, call `login` again and write its `session_toml` to `<app id>/.cori/session`.
5. **The first release.** In `<app id>/`, run `cori deploy`. The front is already built, so this first release needs
   neither npm nor Deno. Give the user the preview URL it prints.
6. **What to try**, briefly:
   - The preview runs on sandbox data of its own. Nothing is live until a person makes the release live in the Cori
     console; an agent session cannot.
   - New request: up to 100 € is approved at once by a rule; above that, or for travel, it waits in Approvals for a
     manager. The user holds both of the app's roles (`member`, `manager`) as its owner.
   - The model step runs on the organization's model or, until someone adds a provider in the console (Platform ›
     LLM), on Cori's free starter model: a few calls a day, and nothing confidential.
7. **Next.** Offer to make the app theirs: what it should track, the approval rule, the screens. Read the app's
   `AGENTS.md`, then follow the `build-app` skill.

In a host without a shell (claude.ai chat), steps 2, 4 and 5 cannot run: do steps 1 and 3, say that the first release
needs Claude Code or Cowork, and once a release exists, show it with the `preview` tool.
