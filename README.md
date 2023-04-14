## 认识yaml

YAML的全称是 Yet Another Markup Language，相比JSON，这两者的区别在于

- YAML的可读性要更好
- YAML支持注释和折叠表达式，你总是不希望看到一串没有任何注释的JSON吧！

首先需要认识下yaml的语法，最简单的方式即是看对应的json

```yaml
dict:
  key1: value1
  key2: value2
list:
  - item1
  - item2
mixed:
  - item1
  - key1: value1
    key2: value2
```

其对应的json是

```json
{
    "dict": {
        "key1": "value1",
        "key2": "value2"
    },
    "list": [
        "item1",
        "item2"
    ],
    "mixed": [
        "item1",
        {
            "key1": "value1",
            "key2": "value2"
        }
    ]
}
```

so，用 `-` 开头即表示数组，`:` 开头即表示对象

## 认识Github Action

Github Action本质上是一系列job合并而来的，我们先来认识job

## 什么是job

```yaml
jobs:
	job1:
    runs-on: ubuntu-latest
    steps:
      - name: Step 1
        run: echo "Step 1"
```

可以看到，一个job包含了几个必须的字段：

- `name`：表示当前 job 的名称，必须唯一；示例中是 `job1`
- `runs-on`：表示运行当前 job 的虚拟机环境；
- `steps`：表示当前 job 的具体执行步骤；
- `needs`：表示当前 job 需要依赖其他 job 的输出结果；
- `env`：表示当前 job 的环境变量；
- `timeout-minutes`：表示当前 job 的最长执行时间。
- `continue-on-error`：指定某个步骤失败时是否继续运行后续步骤；
- `strategy` **：**指定**`job`**的执行策略。

### needs 依赖关系配置

一个依赖关系的job配置示例：

```yaml
jobs:
  job1:
    runs-on: ubuntu-latest
    steps:
      - name: Step 1
        run: echo "Step 1"
  job2:
    runs-on: ubuntu-latest
    needs: job1
    steps:
      - name: Step 2
        run: echo "Step 2"
```

### strategy  策略配置

1. 矩阵策略（Matrix Strategy）

Matrix策略是指针对一个或多个变量进行多次重复执行工作流程的策略。例如，如果你需要测试你的代码在不同版本的操作系统和不同版本的编译器上是否正常运行，你可以使用Matrix策略来并行执行多个不同的测试用例。

1. 并行策略（Parallel Strategy）

Parallel策略是指针对多个作业并行执行的策略。如果你需要同时执行多个作业，例如编译代码、运行测试和部署代码，你可以使用Parallel策略来并行执行这些作业，从而提高工作流程的效率。

1. 序列策略（Sequential Strategy）

Sequential策略是指针对多个作业依次执行的策略。如果你需要按照指定的顺序执行多个作业，例如先编译代码，再运行测试，最后部署代码，你可以使用Sequential策略来依次执行这些作业。

最常用的见于我们打包编译程序时，此时采用矩阵策略是比较好的，示例如下：

```yaml
name: Build and Test

on: push

jobs:
  build:
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macOS-latest]
        compiler: [gcc, clang]
    runs-on: ${{ matrix.os }}
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Build code
        run: make ${matrix.compiler}
      - name: Test code
        run: make test
```

## 应用

### push和release的时候自动打包二进制

### 自动构建Docker