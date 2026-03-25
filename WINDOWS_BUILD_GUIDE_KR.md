# NeoGeo_MiSTer Windows Build Guide

이 문서는 [NeoGeo_MiSTer](/Users/gun/mister-fpg/NeoGeo_MiSTer) 코어를 Windows에서 직접 빌드하는 절차를 정리한 것입니다.

대상 작업:
- NeoGeo 코어 메뉴 한글화 적용본 빌드
- 최종 `.rbf` 생성
- MiSTer SD 카드에 반영

## 1. 준비물

- Windows PC
- Intel Quartus Prime Lite Edition 17.0.2
- 충분한 디스크 여유 공간
- 이 저장소 소스

권장:
- 빌드 경로는 한글/공백 없는 짧은 경로
- 예: `C:\work\NeoGeo_MiSTer`

## 2. Quartus 버전

이 프로젝트는 다음 기준으로 잡혀 있습니다.

- [NeoGeo.qsf](/Users/gun/mister-fpg/NeoGeo_MiSTer/NeoGeo.qsf)
- `LAST_QUARTUS_VERSION "17.0.2 Lite Edition"`

따라서 가장 안전한 버전은:

- `Quartus Prime Lite 17.0.2`

다른 버전은 열릴 수는 있지만, 타이밍/경고/출력 차이가 날 수 있습니다.

## 3. 소스 준비

Windows에 소스를 복사합니다.

예:

```bat
C:\work\NeoGeo_MiSTer
```

중요 파일:

- 프로젝트: [NeoGeo.qpf](/Users/gun/mister-fpg/NeoGeo_MiSTer/NeoGeo.qpf)
- 프로젝트 설정: [NeoGeo.qsf](/Users/gun/mister-fpg/NeoGeo_MiSTer/NeoGeo.qsf)
- 듀얼 SDRAM 프로젝트: [NeoGeo_DualSDR.qpf](/Users/gun/mister-fpg/NeoGeo_MiSTer/NeoGeo_DualSDR.qpf)
- 메뉴 문자열: [neogeo.sv](/Users/gun/mister-fpg/NeoGeo_MiSTer/neogeo.sv)

## 4. 어떤 프로젝트를 빌드할지

보통은 아래 둘 중 하나입니다.

- 단일 SDRAM: `NeoGeo.qpf`
- 듀얼 SDRAM: `NeoGeo_DualSDR.qpf`

일반적으로는 먼저 `NeoGeo.qpf`부터 빌드하는 것이 안전합니다.

## 5. GUI로 빌드하는 방법

1. Quartus 실행
2. `File > Open Project`
3. `NeoGeo.qpf` 선택
4. 프로젝트가 열리면 `Processing > Start Compilation`
5. 완료까지 대기

듀얼 SDRAM 버전이 필요하면:

1. `NeoGeo_DualSDR.qpf` 열기
2. 같은 방식으로 `Start Compilation`

## 6. CLI로 빌드하는 방법

Quartus command shell 또는 일반 `cmd`에서 Quartus가 PATH에 잡혀 있으면 아래처럼 실행할 수 있습니다.

### 기본 프로젝트

```bat
cd /d C:\work\NeoGeo_MiSTer
quartus_sh --flow compile NeoGeo -c NeoGeo
```

### 듀얼 SDRAM 프로젝트

```bat
cd /d C:\work\NeoGeo_MiSTer
quartus_sh --flow compile NeoGeo_DualSDR -c NeoGeo_DualSDR
```

## 7. 출력 파일 위치

출력 경로는 프로젝트에 지정돼 있습니다.

- [NeoGeo.qsf](/Users/gun/mister-fpg/NeoGeo_MiSTer/NeoGeo.qsf)
- [NeoGeo_DualSDR.qsf](/Users/gun/mister-fpg/NeoGeo_MiSTer/NeoGeo_DualSDR.qsf)

둘 다:

- `output_files`

확인할 파일 예:

```bat
output_files\NeoGeo.sof
output_files\NeoGeo.rbf
```

또는 듀얼 SDRAM:

```bat
output_files\NeoGeo_DualSDR.sof
output_files\NeoGeo_DualSDR.rbf
```

주의:
- 프로젝트 설명 문서 [DEV_NOTES.md](/Users/gun/mister-fpg/NeoGeo_MiSTer/DEV_NOTES.md) 에는 `neogeo-lite.rbf` 언급이 있지만, 실제 출력 파일명은 현재 프로젝트 revision 기준으로 확인하는 것이 맞습니다.

## 8. 빌드 성공 확인

성공 기준:

- `Flow Status: Successful`
- `output_files` 안에 `.rbf` 생성

실패 시 먼저 볼 것:

- Quartus 버전이 17.0.2인지
- 소스 경로에 한글/공백이 있는지
- 필요한 IP/QIP 파일이 다 있는지

## 9. MiSTer SD 카드 반영

생성된 `.rbf`를 MiSTer SD 카드에 복사합니다.

보통 위치:

- `_Console`
- 또는 `_Arcade`

예:

```bat
copy output_files\NeoGeo.rbf X:\_Console\NeoGeo_20250909_ko.rbf
```

기존 파일을 덮어쓸 수도 있지만, 처음에는 새 이름으로 테스트하는 것을 권장합니다.

권장:

- 기존 파일 백업
- 새 파일명에 `_ko` 또는 날짜 붙이기

예:

```bat
copy X:\_Console\NeoGeo_20250909.rbf X:\_Console\NeoGeo_20250909.bak.rbf
copy output_files\NeoGeo.rbf X:\_Console\NeoGeo_20250909_ko.rbf
```

## 10. 실기 테스트

MiSTer에서 NeoGeo 코어를 실행한 뒤 아래를 확인합니다.

- 메뉴 제목과 옵션이 한글로 보이는지
- 글자가 잘리지 않는지
- 방향키/선택이 정상인지
- 코어가 정상 로드되는지
- 게임 실행과 메모리 카드 기능에 이상이 없는지

## 11. 지금 수정된 한글화 파일

핵심 수정 파일:

- [neogeo.sv](/Users/gun/mister-fpg/NeoGeo_MiSTer/neogeo.sv)

해당 파일의 `CONF_STR`가 NeoGeo 코어 OSD 메뉴 문자열입니다.

## 12. GitHub 반영 상태

포크 저장소:

- `https://github.com/devilcg/NeoGeo_MiSTer`

한글화 커밋:

- `bb785bf`

릴리즈:

- `https://github.com/devilcg/NeoGeo_MiSTer/releases/tag/korean-menu-bb785bf`

## 13. 추천 작업 순서

1. `Quartus Prime Lite 17.0.2` 설치
2. `NeoGeo.qpf` 빌드
3. `output_files`의 `.rbf` 확인
4. SD 카드에 백업 후 복사
5. 실기 메뉴 확인
6. 필요하면 추가 문자열 수정 후 재빌드
