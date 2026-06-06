# Zametki

Minimal flow for the QML bridge and Markdown export.

## QML bridge (AppState)

Exposed methods:
- `getAllDocuments()` -> list of `{ id, title, tags, blocksCount }` maps.
- `openDocument(id)` -> load document by id.
- `saveDocument()` -> persist current document.
- `searchDocuments(query)` -> list of `{ id, title, tags, blocksCount }` maps.
- `getBacklinks(noteId)` -> list of `{ id, title, tags, blocksCount }` maps.
- `exportCurrentToMarkdown()` -> exports current snapshot to `exports/{id}.md`.

Feature flag:
- `blockEditorEnabled` is stored in `QSettings` under `features/blockEditorEnabled`.

## Markdown export

The exporter writes Markdown to `exports/{id}.md` under the app data directory.
Paragraph, heading, and todo blocks are supported, with todo metadata embedded inline.

