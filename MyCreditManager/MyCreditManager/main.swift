
import Foundation

var isKeepGoing = true
// 학생 객체를 담는 리스트
var studentList: [Student] = []
// 학생 구조체 - 이름, 과목(리스트), 성적 - 과목 인덱스를 키값, 성적을 밸류로 가지는 딕셔너리
struct Student: Equatable {
    var name: String = ""
    var subjects: [String] = []
    var gradeOfSubject: [Int: String] = [:]
}

// 번호별 기능 입력 판별해 옵션 내의 있는 경우 해당 옵션 값을 리턴
// 옵션 번호가 잘못 되었을때는 0을 리턴
func suggestOptions() -> Int {
    print("원하는 기능을 입력해주세요\n1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5:평점보기, X: 종료")
    let chosen = readLine()!
    
    if chosen == "X" || chosen == "x" {
        // 종료 플래그
        isKeepGoing = false
        return 0
    }else if let chosen = Int(chosen) {
        if chosen <= 5 && chosen > 0 {
            return chosen
        }
    }
    print("뭔가 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
    return 0
}

// 옵션 번호별 함수 실행
func executeOption(option: Int) {
    switch option {
    case 1:
        addStudent()
    case 2:
        deleteStudent()
    case 3:
        addGrade()
    case 4:
        deleteGrade()
    case 5:
        checkAvg()
    default:
        break
    }
}
// 빈 입력 판별 함수
func checkInput(input: String) -> Bool {
    // 입력 문자열의 공백 제거
    let trimString = input.trimmingCharacters(in: .whitespaces)
    // 공백을 제거한 문자열이 빈 문자열이면 입력이 공백으로 이루어진 문자열이므로 return false
    if trimString == "" {
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
        return false
    }
    return true
}

// 학생추가
func addStudent() {
    print("추가할 학생의 이름을 입력해주세요")
    let studentName = readLine()!
    if !checkInput(input: studentName) {
        return
    }
    let student = Student(name: studentName)
    if studentList.contains(where: {$0 == student}) {
        print("\(student.name)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
    } else {
        studentList.append(student)
        print("\(student.name) 학생을 추가했습니다.")
    }
}

// 학생 삭제
func deleteStudent() {
    print("삭제할 학생의 이름을 입력해주세요")
    let studentName = readLine()!
    if !checkInput(input: studentName) {
        return
    }
    
    let student = Student(name: studentName)
    if studentList.contains(where: {$0 == student}) {
        if let index = studentList.firstIndex(where: { $0 == student }) {
            studentList.remove(at: index)
        }
        print("\(studentName) 학생을 삭제하였습니다.")
        
    } else {
        print("\(studentName) 학생을 찾지 못했습니다.")
    }
}

// 성적 추가
func addGrade() {
    print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.")
    print("입력예) Mickey Swift A+")
    print("만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.")
    
    let nameSubGrade = readLine()!
    if !checkInput(input: nameSubGrade) {
        return
    }
    // name,subject,grade를 순서대로 갖는 배열로 변환
    let nameSubGradeArr = nameSubGrade.components(separatedBy: " ")
    
    // 입력값이 이름,과목,성적 의 세개 요소가 아니면 리턴
    if nameSubGradeArr.count != 3 {
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
        return
    }
    let student = Student(name: nameSubGradeArr[0])
    // studentList에 student의 name이 일치하는게 있는지 확인
    if let index = studentList.firstIndex(where: { $0.name == student.name }) {
        // 일치하는 name이 있을때 학생의 subject가 일치하는게 있는지 확인
        if let index2 = studentList[index].subjects.firstIndex(of: nameSubGradeArr[1]) {
            // 과목의 인덱스를 키값으로 밸류 값 할당
            if let _ = studentList[index].gradeOfSubject[index2] {
                // 점수 갱신
                studentList[index].gradeOfSubject[index2] = nameSubGradeArr[2]
                
                print("\(nameSubGradeArr[0]) 학생의 \(nameSubGradeArr[1]) 과목이 \(nameSubGradeArr[2])로 추가(변경) 되었습니다")
            }
            // 성적을 추가하고자 하는 과목이 존재하지 않을때
        } else {
            // subjects 배열에 과목 추가
            studentList[index].subjects.append(nameSubGradeArr[1])
            // 방금 추가한 과목의 인덱스
            let subIndex = studentList[index].subjects.count - 1
            // 성적 추가
            studentList[index].gradeOfSubject[subIndex] = nameSubGradeArr[2]
            print("\(nameSubGradeArr[0]) 학생의 \(nameSubGradeArr[1]) 과목이 \(nameSubGradeArr[2])로 추가(변경) 되었습니다")
        }
    } else {
        print("\(nameSubGradeArr[0]) 학생을 찾지 못했습니다.")
    }
    
}

// 성적 삭제
func deleteGrade() {
    print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해 주세요.")
    print("입력예) Mikey Swift")
    
    let nameSubGrade = readLine()!
    if !checkInput(input: nameSubGrade) {
        return
    }
    // name,subject를 순서대로 갖는 배열로 변환
    let nameSubArr = nameSubGrade.components(separatedBy: " ")
    
    // 입력값이 이름,과목 두 개 요소가 아니면 리턴
    if nameSubArr.count != 2 {
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
        return
    }
    let student = Student(name: nameSubArr[0])
    // studentList에 student의 name이 일치하는게 있는지 확인
    if let index = studentList.firstIndex(where: { $0.name == student.name }) {
        // 일치하는 name이 있을때 학생의 subject가 일치하는게 있는지 확인
        if let index2 = studentList[index].subjects.firstIndex(of: nameSubArr[1]) {
            studentList[index].subjects.remove(at: index2)
            studentList[index].gradeOfSubject.removeValue(forKey: index2)
            print("\(nameSubArr[0]) 학생의 \(nameSubArr[1]) 과목이 삭제 되었습니다")
        // 해당하는 과목이 없을때
        } else {
            print("\(nameSubArr[1]) 과목을 찾지 못했습니다.")
        }
    } else {
        print("\(nameSubArr[0]) 학생을 찾지 못했습니다.")
    }
}

// 평점 보기
func checkAvg() {
    print("평점을 알고싶은 학생의 이름을 입력해주세요")
    let name = readLine()!
    if !checkInput(input: name) {
        return
    }
    let student = Student(name: name)
    // studentList에 student의 name이 일치하는게 있는지 확인
    if let index = studentList.firstIndex(where: { $0.name == student.name }) {
        let subjects = studentList[index].subjects
        let grades = studentList[index].gradeOfSubject
        var sumOfGrades = 0.0
        var gradeCount = subjects.count
        
        for i in 0..<subjects.count {
            let subject = subjects[i]
            if let grade = grades[i] {
                sumOfGrades += transGrade(grade: grade)
                print("\(subject): \(grade)")
            } else {
                // 성적이 없는 과목에 대한 처리
                gradeCount -= 1
                print("\(subject): 없음")
            }
        }
        
        let avgGrade = sumOfGrades / Double(gradeCount)
        print("평점: \(avgGrade)")
    } else {
        print("\(name) 학생을 찾지 못했습니다.")
    }
}

// 성적 변환하여 점수를 리턴 하는 함수
func transGrade(grade: String) -> Double {
    switch grade {
    case "A+":
        return 4.5
    case "A":
        return 4.2
    case "A-":
        return 4.0
    case "B+":
        return 3.5
    case "B":
        return 3.3
    case "B-":
        return 3.0
    case "C+":
        return 2.5
    case "C":
        return 2.3
    case "C-":
        return 2.0
    case "D+":
        return 1.5
    case "D":
        return 1.3
    case "D-":
        return 1.0
    default:
        return 0
    }
}

// 실행 구문
while isKeepGoing {
    let option = suggestOptions()
    if option != 0 {
        executeOption(option: option)
    }
}
print("프로그램을 종료합니다...")







