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
- `skills/`
- `assets/`

## 메모

이 플러그인은 starter bundle이다. 핵심 가치는 커스텀 실행 래퍼보다 프롬프트, 스킬, 정책 문서에 둔다.

## CLI 요구사항

- 이 플러그인은 공식 Obsidian CLI를 기준으로 설계됐다
- 현재 환경에서는 Obsidian이 이미 실행 중일 때 raw CLI 명령이 정상 동작했다
- 앱을 완전히 종료한 뒤에는 `obsidian version`, `obsidian create` 모두 앱을 다시 열기 전까지 실패했다
- 워크플로는 CLI 사용 가능 여부를 확인하고, 실행 실패 시 분명한 fallback 메시지를 제공해야 한다

공식 문서:
- https://obsidian.md/help/cli

## 검증된 CLI 예시

아래 명령은 별도 표기가 없는 한 현재 vault 기준으로 실제 실행에 성공했다.

```bash
obsidian version
obsidian daily:path
obsidian create path="Codex Plugin Tests/CLI Direct Test Target.md" content="# CLI Direct Test Target\n\n- target note for backlink testing" overwrite
obsidian create path="Codex Plugin Tests/CLI Direct Test Source.md" content="# CLI Direct Test Source\n\nThis note links to [[CLI Direct Test Target]].\n\n- created for direct CLI validation" overwrite
obsidian read path="Codex Plugin Tests/CLI Direct Test Target.md"
obsidian append path="Codex Plugin Tests/CLI Direct Test Target.md" content="\n- appended line from direct CLI test"
obsidian search query="CLI Direct Test"
obsidian backlinks path="Codex Plugin Tests/CLI Direct Test Target.md" counts format=json
obsidian links path="Codex Plugin Tests/CLI Direct Test Source.md"
obsidian property:set path="Codex Plugin Tests/CLI Direct Test Target.md" name=status value=verified type=text
obsidian property:read path="Codex Plugin Tests/CLI Direct Test Target.md" name=status
obsidian daily:append content="- [ ] direct CLI validation" inline
obsidian unresolved total
obsidian orphans total
```

완전 종료 시 관찰된 동작:

```bash
osascript -e 'tell application "Obsidian" to quit'
obsidian version
# -> The CLI is unable to find Obsidian. Please make sure Obsidian is running and try again.
```

## 사용 예시

- "`Plugin Example Note`라는 이름으로 지금 대화를 새 Obsidian 노트로 정리해줘."
- "`Plugin Example Note.md`에 후속 체크리스트를 덧붙여줘."
- "내 vault에서 `zettelkasten` 관련 노트를 찾아 요약해줘."
- "`Plugin Example Note`의 backlinks를 보여줘."

## 구현 문서

- `docs/cli-mapping.md`: 공식 Obsidian CLI 기준 workflow-to-command 매핑 문서

## Hook 정책

- `hooks.json`은 CLI readiness, safe write, post-write verification, destructive command protection용 starter guardrail을 정의한다

## 실행 모델

- 플러그인 전용 shell runner 대신 공식 `obsidian` CLI를 직접 사용한다
- 명령 선택 규칙은 skills, agents, docs에 두어 upstream CLI 변화에 더 쉽게 대응한다
- 최종 사용자는 여전히 자연어 요청으로 사용하지만, 내부 실행 표면은 raw CLI다

## 에셋

- `assets/`에는 manifest용 보라 계열 보석 스타일 SVG 아이콘과 로고가 들어 있다
- 더 다듬은 공개용 비주얼이 필요하면 나중에 교체하면 된다
