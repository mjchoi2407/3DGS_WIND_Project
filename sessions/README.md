<!-- template: sessions_README.template.md -->
<!-- template-version: 2026-04-30 19:29:34 KST -->
<!-- localized-for: Wind_Deformable_3DGS -->

# 루트 Sessions

이 폴더는 Wind3DGS project container 자체에 대한 관리성 기록만 남긴다.

## 사용 범위

루트 `sessions/`에 기록해도 되는 내용:

- repository split 정책
- workspace-level 설정과 마이그레이션
- 공통 기록 언어/로그 정책
- `code/`, `ideas/`, `experiments/` 중 하나에만 귀속되지 않는 프로젝트 운영 기록
- 여러 하위 저장소에 걸친 coordination 요약

루트 `sessions/`에 기록하지 않는 내용:

- 코드 구현, 테스트, 리팩터링 기록 -> `code/sessions/`
- 연구 아이디어, 논문 방향, checklist, reference 기록 -> `ideas/sessions/`
- 실험 데이터, 학습, 모델, 산출물, 보고서 기록 -> `experiments/sessions/`

이 노트들은 extension history가 섞였을 때 project-container 수준의 맥락을 회복하기 위한 용도다.

권장 파일명:

```text
YYYY-MM-DD_NN_short_topic.md
```

`NN`은 이 `sessions/` 폴더 안에서 같은 날짜에 만든 기록의 두 자리 순번이다. `01`부터 시작해서 생성 순서대로 증가시킨다. 기존 unnumbered legacy note는 사용자가 명시적으로 migration을 요청하지 않는 한 그대로 둔다.

권장 형식:

```markdown
# YYYY-MM-DD NN 짧은 주제

## 배경

## 결정

## 변경 파일

## 다음 단계
```
