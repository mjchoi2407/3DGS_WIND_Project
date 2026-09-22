# 공통 운영 기록

## 현재 상태

2026-09-22: [지침·기록 구조화의 현재 상태](2026-09-10_01_token_context_optimization.md#현재-상태). 필수 원칙·조건부 절차·주제별 인계와 상세 절 링크로 분리. [적용 범위·검증](2026-09-10_01_token_context_optimization.md#2026-09-22-검증).

2026-09-20: [GPU teacher 실행 지침 연결](2026-09-20_01_gpu_runtime_guidance.md). 최상위 `AGENTS.md`에 GPU별 Mixed32·Newmark/Gauss 선택 계약을 필수 참조로 연결했다.

2026-09-14: [정리 요청의 R 문서 동기화 정책](2026-09-14_01_r_document_sync_policy.md). 관련 R 본문·체크리스트·근거 및 PDF/bundle 확인을 정리 범위에 포함한다.

2026-09-12 후속: [서브컴 결과 전용 공유](../docs/network/sub_results_share.md) 생성·실제 SMB 쓰기/읽기/경계 검증 완료. 메인컴 전용 디렉터리에 저장하며 서브컴 관리자 마운트는 대기.

2026-09-12: [메인컴·서브컴 WSL2 설정](2026-09-12_01_two_pc_setup_guides.md). 메인컴 Samba 설치·읽기 전용 검증·Windows 전달과 상대 IP 제한 완료. 서브컴 실제 접속·공유 암호 입력·자동 복구 검증은 남음. [인계](../docs/network/main_pc_status.md).

2026-09-10: [독립 작업 병렬 처리 원칙](2026-09-10_02_parallel_execution_policy.md) 추가. 일반 작업은 병렬 처리를 기본으로 하되 속도 측정·의존성·자원 경쟁은 예외로 둔다.

## 기록 범위

Root는 공통 정책·환경·저장소 조정만 기록한다. 구현은 code, 연구는 ideas, 실험은 experiments의 sessions를 사용한다.
기록 기준과 파일명은 [공통 기록 규칙](../AGENTS.md#간결한-작업-기록)을 따른다.
과거 운영 근거는 관련 note에 명시된 문서·절 링크로 확인한다. 링크가 없거나 필요한 정보가 부족할 때만 이 폴더부터 검색 범위를 넓힌다. 날짜 기준 전량 읽기는 하지 않는다.
