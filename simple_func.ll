; ModuleID = 'main'
source_filename = "main"

%function_0_env = type { i8*, i32 }
%main_env = type {}
%function_0_closure = type { i32 (i8*, i32)*, i8* }

declare i8* @malloc(i32)

define internal i32 @function_0(i8*, i32) {
entry:
  %2 = call i8* @malloc(i32 16)
  %curr_env = bitcast i8* %2 to %function_0_env*
  %a = getelementptr inbounds %function_0_env, %function_0_env* %curr_env, i32 0, i32 1
  store i32 %1, i32* %a
  %3 = getelementptr inbounds %function_0_env, %function_0_env* %curr_env, i32 0, i32 0
  store i8* %0, i8** %3
  %4 = load i32, i32* %a
  %5 = add i32 %4, 4
  ret i32 %5
}

define internal i32 @main() {
entry:
  %0 = call i8* @malloc(i32 0)
  %curr_env = bitcast i8* %0 to %main_env*
  %1 = call i8* @malloc(i32 16)
  %2 = bitcast i8* %1 to %function_0_closure*
  %3 = getelementptr inbounds %function_0_closure, %function_0_closure* %2, i32 0, i32 0
  store i32 (i8*, i32)* @function_0, i32 (i8*, i32)** %3
  %4 = getelementptr inbounds %function_0_closure, %function_0_closure* %2, i32 0, i32 1
  %5 = bitcast %main_env* %curr_env to i8*
  store i8* %5, i8** %4
  ret i32 0
}

