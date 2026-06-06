export function wrapSelection(editor, prefix, suffix) {
    if (!editor) {
        return false;
    }

    const start = Math.min(editor.selectionStart, editor.selectionEnd);
    const end = Math.max(editor.selectionStart, editor.selectionEnd);
    const selected = editor.text.slice(start, end);
    const before = editor.text.slice(0, start);
    const after = editor.text.slice(end);
    const wrapped = prefix + selected + suffix;
    editor.text = before + wrapped + after;
    const cursor = start + prefix.length + selected.length;
    editor.cursorPosition = cursor;
    editor.select(cursor, cursor);
    return true;
}

export function tryBlockShortcut(appState, blockId, text) {
    if (!appState || !blockId) {
        return null;
    }

    const rules = [
        { match: "### ", type: "heading", level: 3, strip: 4 },
        { match: "## ", type: "heading", level: 2, strip: 3 },
        { match: "# ", type: "heading", level: 1, strip: 2 },
        { match: "- [ ] ", type: "todo", level: 1, done: false, strip: 6 },
        { match: "- [x] ", type: "todo", level: 1, done: true, strip: 6, ignoreCase: true },
        { match: "[] ", type: "todo", level: 1, done: false, strip: 3 },
    ];

    for (const rule of rules) {
        const prefix = rule.match;
        const matches = rule.ignoreCase
            ? text.length >= prefix.length && text.slice(0, prefix.length).toLowerCase() === prefix.toLowerCase()
            : text.startsWith(prefix);
        if (!matches) {
            continue;
        }

        if (text.length !== prefix.length) {
            continue;
        }

        appState.convertBlockType(blockId, rule.type, rule.level || 1, rule.done === true);
        return text.slice(rule.strip);
    }

    return null;
}

export function headingFontSize(level, palette) {
    if (level >= 3) {
        return palette.fontSizeLg;
    }
    if (level === 2) {
        return palette.fontSizeXl;
    }
    return palette.fontSizeXxl;
}

export function blockPlaceholder(blockType) {
    void blockType;
    return "";
}
