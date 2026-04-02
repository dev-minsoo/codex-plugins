# Custom Codex Plugins

유용한 커스텀 Codex 플러그인을 모아두는 로컬 모노레포다.

## 구조

```text
codex-plugins/
├── .agents/plugins/marketplace.json
├── plugins/
└── README.md
```

## 로컬 적용 방법

1. 플러그인은 `./plugins/<plugin-name>` 아래에 둔다.
2. `./.agents/plugins/marketplace.json`에 플러그인을 등록한다.
3. 이 저장소를 로컬 플러그인 소스로 사용할 때 Codex가 이 마켓플레이스 경로를 읽도록 맞춘다.

## 마켓플레이스 예시

```json
{
  "name": "custom-codex-plugins",
  "interface": {
    "displayName": "Custom Codex Plugins"
  },
  "plugins": []
}
```

## 현재 포함된 플러그인

- `obsidian`: Obsidian CLI 기반의 note capture, vault research, backlink curation 워크플로 번들

## 비고

- 영어 문서는 `README.md`
- 한국어 문서는 `README.ko.md`
- Obsidian 플러그인 상세 문서는 `plugins/obsidian/README.md`
