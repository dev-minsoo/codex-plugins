# Obsidian Plugin

이 플러그인은 `plugins/obsidian` 아래에서 Obsidian 중심 Codex 워크플로를 번들 형태로 제공한다.

## 포함된 워크플로

- `obsidian-note-capture`
- `obsidian-vault-research`
- `obsidian-backlink-curator`

## 에이전트 구성

- `openai`: vault를 관리하는 knowledge gardener
- `graph-analyzer`: 연결 구조와 orphan note 분석
- `markdown-styler`: Obsidian Markdown 정리와 구조화
- `note-refiner`: 노트 중심 재작성 및 분리

## 다루는 범위

- 대화, 회의 메모, 초안 내용을 Obsidian 친화적인 Markdown으로 정리
- note title, link, tag, metadata를 기준으로 vault 조사
- backlink, 관련 노트, 후속 구조 개선 포인트 제안
- 공식 Obsidian CLI를 통한 note workflow 실행

## 플러그인 구조

- `.codex-plugin/plugin.json`
- `hooks.json`
- `agents/`
- `docs/`
- `scripts/`
- `skills/`
- `assets/`

## 메모

이 플러그인은 starter bundle이다. 플러그인 표면과 번들형 skill 구조를 먼저 정의하고, 구체적인 CLI 실행 wiring은 다음 단계 구현으로 남겨 둔다.

## CLI 요구사항

- 이 플러그인은 공식 Obsidian CLI를 기준으로 설계됐다
- Obsidian이 열려 있지 않으면 첫 CLI 명령이 앱 실행을 유도할 수 있다
- 후속 구현에서는 CLI 사용 가능 여부를 감지하고, 실행 실패 시 분명한 fallback 메시지를 제공해야 한다

## 사용 예시

- "`Plugin Example Note`라는 이름으로 지금 대화를 새 Obsidian 노트로 정리해줘."
- "`Plugin Example Note.md`에 후속 체크리스트를 덧붙여줘."
- "내 vault에서 `zettelkasten` 관련 노트를 찾아 요약해줘."
- "`Plugin Example Note`의 backlinks를 보여줘."

## 구현 문서

- `docs/cli-mapping.md`: 공식 Obsidian CLI 기준 workflow-to-command 매핑 문서

## Hook 정책

- `hooks.json`은 CLI readiness, safe write, post-write verification, destructive command protection용 starter guardrail을 정의한다

## 로컬 Runner

- `scripts/obsidian-cli-runner.sh`는 번들된 CLI 워크플로를 감싸는 작은 실행 래퍼다
- 직접적인 CLI나 runner 명령은 구현 세부사항이고, 최종 사용자는 자연어 요청으로 쓰는 것을 기준으로 한다

## 에셋

- `assets/`에는 manifest용 보라 계열 보석 스타일 SVG 아이콘과 로고가 들어 있다
- 더 다듬은 공개용 비주얼이 필요하면 나중에 교체하면 된다
