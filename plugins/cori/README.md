# Cori

Build internal apps on [Cori](https://cori.do) from Claude: durable workflows with roles, approvals and an audit
trail, governed data stores, and a hosted React front. This plugin connects Claude to Cori Cloud and teaches it how a
Cori app is written, checked and deployed.

- **MCP server `cori`** (`https://app.cori.do/mcp`): your apps, short-lived sessions for the `cori` command line, your
  organization's connectors, previews of your releases. You sign in with your Cori account the first time (OAuth, in
  your browser); Claude never sees your password.
- **Skill `build-app`**: how to write, check, run and deploy a Cori app (workflows, stores, the front).
- **Command `/cori:start`**: a first app, from nothing to its preview URL.

## Several organizations

Claude works in the organization you signed in to (the browser asks which one when you belong to several). To work in
two from Claude Code, add the server a second time under another name, and sign that one in to the other organization:
`claude mcp add --transport http cori-<organization> https://app.cori.do/mcp`. An app folder belongs to the
organization it was made in: the `cori` command line uses your login to that one there (`cori login --org <slug>`).

## What it runs, sends and fetches

- The plugin itself runs nothing: it is text and one server address. It has no hooks and no programs.
- `/cori:start` asks Claude to run, in your terminal and with your approval: `cori --version`; `npm install -g
  @cori-do/cli` when the command line is missing (from the npm registry); `cori init`, which writes the app's folder
  from a template the command line carries; `cori deploy`, which uploads that folder to Cori Cloud
  (`https://app.cori.do`), where the release runs on sandbox data of its own.
- The MCP server receives what Claude asks of it (app ids, the tool calls above) and answers from your organization's
  data on Cori Cloud.
- An app's model steps run on your organization's model provider, or on Cori's free starter model until you add one:
  do not send confidential data to the starter model.

Terms: https://www.cori.do/terms · Privacy: https://www.cori.do/privacy
