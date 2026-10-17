# Installing Levirge Brain

Levirge Brain is a remote MCP server: there is nothing to download, build or run locally.

- Endpoint: `https://brain.levirge.com/mcp`
- Transport: Streamable HTTP
- Auth: OAuth 2.0, negotiated on first connect; a per-user bearer token is the fallback
- Account: a Levirge Brain workspace — sign up at https://signup.levirge.com/brain

## 1. Add the server

In Cline's MCP settings file (`cline_mcp_settings.json`):

```json
{
  "mcpServers": {
    "brain": {
      "type": "streamableHttp",
      "url": "https://brain.levirge.com/mcp"
    }
  }
}
```

`"type": "streamableHttp"` is required: Cline treats a `url` entry with no `type` as SSE.

## 2. Sign in

On first connect the server answers `401` with OAuth metadata, and the client opens the Levirge
sign-in page (`auth.levirge.com`). Approving it connects the session to the user's workspace.

Bearer-token fallback, for clients without OAuth: the user mints a token on their Brain profile
page (`https://brain.levirge.com/profile`) and the entry gains a header:

```json
"headers": { "Authorization": "Bearer <token>" }
```

## 3. Verify

`kb_overview` is read-only and takes no arguments. It returns the workspace's readiness, document
counts, and its vaults, tags, entities and sources. A response with `"ready": true` means the
server is connected and authorised.

## Tools

20 tools: search and retrieval (`search_knowledge`, `get_document`, `list_documents`), capture
(`add_knowledge`, `mutate_knowledge`), entities and graph (`get_entity`, `list_entities`,
`knowledge_graph`, `get_context_pack`), workspace summaries (`kb_overview`, `get_vault_profile`),
skills, handoffs, todos, reminders, work sessions, feedback and API tokens. Read-only tools are
annotated `readOnlyHint: true`.

Docs: https://levirge.com/brain/docs
