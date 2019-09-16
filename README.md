### Intro - JSON Parser

- 콘솔 프로그램
- JSON 문자열을 입력받아 Tokenizer, Parser, 출력하는 프로그램 만들기



### 요구/습득 지식

- 문자열 처리
- Stack 자료구조
- StringInterpolation (swift 5)
- Unit test
- Regular Expression
- 사용자 정의 연산자 



## STEP 1

### 요구사항

- 콘솔 입력으로 단순 배열 문자열 입력이 주어질 때, 배열 요소 데이터가 문자열/숫자/Bool 값임을 구분하여 개수 출력
- 정규식 사용하지 않기



### 구현사항 

- JSON 표준 규격 공부

- 입력 문자열에 대해 String.split 또는 String.component 메서드를 사용하여 문자 요소를 추출

  ##### Lexer : 입력된 각 문자열 요소들의 데이터 타입 판별용 구조체. tokenizer를 겸함 

  - 입력 문자열 토큰화 하고, 각각의 요소(문자열)의 자료형을 판별하여, typealias LexPair(타입정보, 문자열)를 반환하는 기능을 추가
  - 위 Lexer 구조체의 결과를 입력으로 구조체 이니셜라이저 구현.
    - 배열에 여러 타입을 저장하기 위해 JsonArray 구조체 내에 각각의 타입별로 배열을 생성. 
    - 원본의 순서를 보장하기 위한 배열을 별도로 둠

  ##### Parser : LexPair 배열을 기반으로 JsonArray 구조체를 반환하는 기능을 담당.

- 유효성 체크를 위한 Validation 구현 과정에서 swift에서 기본지원하지 않는 단항 연산자 (&=) 를 사용자 정의 연산자를 통해 구현



### 미비사항

- String.split 기준인 공백, comma, brackets( {, }, [, ] )  등에 대해 요소 여부 판별 불가능 
  - (ex: "Jessie Thompson" ->  "Jessie", "Thompson"으로 분리됨)

----

----



## STEP 2

### 요구사항 

- JSON Object 형식의 입력도 가능하도록 개선
  - JSON 객체 문자열 입력시 Dictionary 로 변환
  - JSON Array 내부에는 JSON Object 객체 포함 가능,  [ { "name" : "Doran"}, {"level": 5}]
  - JSON Object 내부에는 JSON Array 포함 여부 미지원해도 괜찮음. { "name" : [ "Dominic", "Doran" ] }
- 정규표현식 사용하지 않고 최대한 문자열 처리



### 구현사항 및 개선사항

- 기존 코드를 개선
  - 기존 코드의 토큰화 과정은 다소 러프하게 작성된 측면이 있음.
  - 토큰화 과정을 세밀하게 구분 짓기. 토크나이저와 파서의 역할을 명확하게 재설정
- Tokenizer를 `Stack` 을 이용하여 구현
  - Generic Type을 사용하여 `Stack` 구현
- STEP 1의 미비사항에 대해서도 요소의 토큰화를 구현할 수 있도록 개선
- 입력 문자열을 토큰화하는 과정에서 주어진 조건의 JSON Value(Object, Array) 포맷에 대해 입력되는 문자들을 전처리 
  - `tokenizeWithWhiteSpace`, `tokenizeWithComma`, `tokenizeWithSquareBrackets`, `tokenizeWithCurlyBrackets`, `tokenizeWithSemicolon` 등의 메서드로 토큰화 과정에서 전처리를 실시 
  - [Tokenizer 소스](https://github.com/hwj0623/swift-jsonparser/blob/jsonparser-step2/JSONParser/JSONParser/Tokenizer.swift)
  - 문자열 내의 특수문자 사용과  JSON Object, JSON Array 에서의 특수문자들( "{" ,"}" ,  "," , ":" ,"[", "]" ) 을 구별하기 위해 Stack 처리과정에서 토큰화할 문자열에 대해 prefix, suffix 문자를 joined 시킴으로써 일반적인 String 문자열 내의 요소와 구별짓고자 함.
- 문자열(\\"\\") 입력시 스택을 사용하여 문자열 내의 문자인지, JSON Object 또는 Array 인지를 구분할 수 있도록 함.
- **재귀 호출 방식**으로 `중첩 JSON 구조 `를 담을 수 있도록 코드 개선. 
  - 요구사항에서 더 나아가서 function call stack 이 허용하는 한도 내에서 **반복되는 중첩 구조의 JSON 입력을 처리할  수 있도록 개선**
  - [Parser 소스](https://github.com/hwj0623/swift-jsonparser/blob/jsonparser-step2/JSONParser/JSONParser/Parser.swift)





----

---



## STEP 3 

- 입력 문자열에 대해  JSON 문법 규칙 검사를 위한 검사기능 추가구현
- Regular Expression를 사용하여 구현 

- 가령, JSON Object 내의  key의 value 값으로 Array는 허용되지 않는 이전스텝의 조건을 검사해야 함.

  ```json
  입력 : { "name" : "Doran", "alias" : "summoner", "level" : 32, "tier" : ["bronze", "silver", "gold"] }
  출력 : 지원하지 않는 형식을 포함하고 있습니다.
  ```



### 구현사항 

- 주의 : swift 정규식에서 ", [] 등과 같은 문자열은 escape slash가 2개 들어가야 함.
- JSON Object와 JSON Array의 패턴,  JSON Array 내의  Object 중첩 검사 패턴을 작성
  - [GrammerChecker](https://github.com/hwj0623/swift-jsonparser/blob/jsonparser-step3/JSONParser/JSONParser/GrammarChecker.swift)

- **Unit Test **를 통해 문제의 요구조건에 맞는 입력을 테스트 후 구현 
  - [GrammerCheckerUnitTest](https://github.com/hwj0623/swift-jsonparser/blob/jsonparser-step3/JSONParser/JSONParserUnitTest/GrammerCheckerUnitTest.swift)



----

----





## STEP 4

- JSON Object, JSON Array의 중첩구조 (1회) 를 허용하도록 변경

  

### 구현사항 

- 반복되는 중첩구조에 대한 것은 STEP 2에서 `Stack` 과 재귀함수호출을 통해 구현하였으므로 생략.
- [Unit Test](https://github.com/hwj0623/swift-jsonparser/blob/jsonparser-step4/JSONParser/JSONParserUnitTest/GrammerCheckerUnitTest.swift) 및 문법규칙 체크를 위한 [GrammarChecker](https://github.com/hwj0623/swift-jsonparser/blob/jsonparser-step4/JSONParser/JSONParser/GrammarChecker.swift) 구조체 개선 

- JSON Value인 Array, Int, Bool, String을 별도 객체로 두지 않고, JSON과 관련된 공통 프로토콜을 확장하도록 개선





----

----



## STEP 5

- 출력 양식을 https://jsonlint.com/ 와 동일하게 표현하도록 변경할 것
  - 배열은 한줄로, 객체는 키/값 별로 개행처리



### 구현사항

- OutputView를 통한 분기처리로 개행을 처리하기에는 한계가 있음
- StringInterpolation Extension을 통해 출력을 구현