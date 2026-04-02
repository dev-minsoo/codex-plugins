# Custom Codex Plugins

A local monorepo for useful custom Codex plugins.

## Structure

```text
codex-plugins/
├── .agents/plugins/marketplace.json
├── plugins/
└── README.md
```

## Use Locally

1. Keep plugins under `./plugins/<plugin-name>`.
2. Register them in `./.agents/plugins/marketplace.json`.
3. Point Codex to this local marketplace layout when using the repo as a local plugin source.

## Marketplace Example

```json
{
  "name": "custom-codex-plugins",
  "interface": {
    "displayName": "Custom Codex Plugins"
  },
  "plugins": []
}
```

## Korean Version

See `README.ko.md`.
