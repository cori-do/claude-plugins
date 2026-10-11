# Cori for Claude

The [Cori](https://cori.do) plugin for Claude Code: Cori Cloud's MCP server, the skill to build Cori apps, and
`/cori:start`, which takes a first app to its preview URL.

In Claude Code:

```bash
claude plugin marketplace add cori-do/claude-plugins
claude plugin install cori@cori
```

(or, in a session, `/plugin marketplace add cori-do/claude-plugins`, then `/plugin install cori@cori`). In claude.ai and
Cowork: Customize › Plugins › Add › Add marketplace, `cori-do/claude-plugins`, install Cori, then connect its Cori
connector from the plugin's Connectors tab. A plugin installed there does not reach Claude Code, nor the other way round.

Then, in Claude Code:

```
/cori:start
```

It installs the `cori` command line from npm if it is missing, has you sign in to Cori (your browser opens; a new user
creates an account there), creates an app from the starter template, deploys it and gives you its preview URL. From
there, ask Claude for the app you want.

## What it adds

| | |
|---|---|
| MCP server `cori` | `https://app.cori.do/mcp`: your apps, sessions for the command line, your organization's connectors. It signs you in with OAuth the first time (`/mcp` in Claude Code). |
| Skill `build-app` | How to write, check, run and deploy a Cori app: workflows, stores, the React front. Claude reads it when you ask for an app. |
| Command `/cori:start` | The first app, from nothing to its preview URL. |

No hooks and no programs: the plugin is text and one server address (what it runs, sends and fetches:
[plugins/cori/README.md](plugins/cori/README.md)). The `cori` command line comes from npm
(`@cori-do/cli`), the details of each command from the installed command line (`AGENTS.md` in every app folder) and
from the server.

Not on Cori Cloud? Your organization's Cori server has its own address: add it with
`claude mcp add --transport http cori https://<your server>/mcp` (its console's Connect page shows it), and use the
skill from this plugin.

In claude.ai chat there is no shell: Claude creates the app there, and its first release needs Claude Code or Cowork.

## Updates

Claude Code does not update plugins from a marketplace like this one by itself (unless you turn it on in
`/plugin` › Marketplaces):

```bash
claude plugin marketplace update cori
claude plugin update cori@cori
```

## Maintainers

The skill is cori-core's `skills/build-app`, copied at each release of the command line, which sets the plugin's
version: `scripts/sync-skill.sh <cori-core checkout> [<tag>]`, then `claude plugin validate --strict plugins/cori` and
`claude plugin validate --strict .`.

## Licence

MIT, Cori Inc.
