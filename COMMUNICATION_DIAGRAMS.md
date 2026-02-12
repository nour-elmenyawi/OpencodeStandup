# Multi-Role OpenCode Communication Diagrams

This document contains visual diagrams showing how roles communicate in multi-role OpenCode sessions.

## 1. System Architecture Overview

```mermaid
flowchart TB
    subgraph "User Interface Layer"
        TM[Tmux 2x2 Grid Layout]
    end
    
    subgraph "Execution Layer - Interactive Sessions"
        ARCH[Architect Session<br/>Waits for User Input]
        DEV[Developer Session<br/>Waits for User Input]
        QA[QA Engineer Session<br/>Waits for User Input]
        REV[Code Reviewer Session<br/>Waits for User Input]
    end
    
    subgraph "Communication Layer"
        NB[(notifications.md<br/>Shared Message Board)]
        
        subgraph "Role State Storage"
            AT[architect/tasks.json<br/>architect/log-*.md]
            DT[developer/tasks.json<br/>developer/log-*.md]
            QT[qa-engineer/tasks.json<br/>qa-engineer/log-*.md]
            RT[code-reviewer/tasks.json<br/>code-reviewer/log-*.md]
        end
    end
    
    subgraph "Orchestration Layer"
        SC[standup script]
        SD[standup-shutdown script]
        SM[standup-metrics script]
        SS[standup-summary script]
    end
    
    USER[User/Facilitator]
    
    SC --> TM
    TM --> ARCH & DEV & QA & REV
    
    USER -->|Instructs| ARCH
    USER -->|Instructs| DEV
    USER -->|Instructs| QA
    USER -->|Instructs| REV
    
    ARCH <-->|Read/Write| NB
    DEV <-->|Read/Write| NB
    QA <-->|Read/Write| NB
    REV <-->|Read/Write| NB
    
    ARCH <--> AT
    DEV <--> DT
    QA <--> QT
    REV <--> RT
    
    USER -.->|Views| NB
    USER -.->|Monitors| TM
    
    SD --> ARCH & DEV & QA & REV
    SM -.->|Analyze| AT & DT & QT & RT
    SS -.->|Aggregate| AT & DT & QT & RT & NB
    
    style NB fill:#ff6b6b,stroke:#c92a2a,stroke-width:3px,color:#fff
    style TM fill:#4ecdc4,stroke:#0a9396,stroke-width:2px
    style USER fill:#95e1d3,stroke:#38a3a5,stroke-width:3px
    style SC fill:#95e1d3,stroke:#38a3a5
```

## 2. Communication Flow - User-Mediated Sequence

```mermaid
sequenceDiagram
    participant U as User/Facilitator
    participant S as Standup Script
    participant A as Architect
    participant D as Developer
    participant Q as QA Engineer
    participant R as Code Reviewer
    participant N as notifications.md
    participant FS as File System (.standup/)
    
    U->>S: Launch standup
    activate S
    S->>FS: Initialize .standup/ structure
    
    par Session Initialization
        S->>A: Start architect session
        S->>D: Start developer session
        S->>Q: Start qa-engineer session
        S->>R: Start code-reviewer session
    end
    
    A->>FS: Read log & tasks
    A->>N: Read notifications
    A-->>U: Morning standup update
    
    D->>FS: Read log & tasks
    D->>N: Read notifications
    D-->>U: Morning standup update
    
    Q->>FS: Read log & tasks
    Q->>N: Read notifications
    Q-->>U: Morning standup update
    
    R->>FS: Read log & tasks
    R->>N: Read notifications
    R-->>U: Morning standup update
    
    Note over A,R: All roles wait for user assignments
    
    deactivate S
    
    rect rgb(200, 220, 250)
        Note over U,D: Feature Development Cycle
        U->>D: Assign: Implement login feature
        activate D
        D->>D: Implement code
        D->>FS: Update tasks.json (in-progress)
        D->>D: Create PR #123
        D->>N: Write: 🟡 IMPORTANT - Feature complete (PR #123)
        D-->>U: Task complete
        deactivate D
    end
    
    rect rgb(250, 220, 200)
        Note over U,Q: QA Testing Cycle (User-Initiated)
        U->>N: Check notifications
        U->>Q: Check notifications and test PR #123
        activate Q
        Q->>N: Read notifications
        Q->>Q: See PR #123 notification
        Q->>Q: Test feature
        Q->>FS: Create bug tasks in tasks.json
        Q->>N: Write: 🔴 URGENT - Found 2 high-priority bugs (PR #123)
        Q-->>U: Testing complete, bugs found
        deactivate Q
    end
    
    rect rgb(220, 250, 220)
        Note over U,R: Code Review Cycle (User-Initiated)
        U->>N: Check notifications
        U->>R: Check notifications and review PR #123
        activate R
        R->>N: Read notifications
        R->>R: See PR #123 notification
        R->>R: Review code
        R->>N: Write: 🟡 IMPORTANT - PR #123 needs changes
        R-->>U: Review complete
        deactivate R
    end
    
    rect rgb(250, 250, 200)
        Note over U,D: Bug Fix & Revision Cycle
        U->>N: Check notifications
        U->>D: Address bugs and review feedback for PR #123
        activate D
        D->>N: Read notifications
        D->>D: See bug reports & review feedback
        D->>D: Fix bugs & address feedback
        D->>FS: Update tasks.json
        D->>N: Write: 🟢 FYI - All feedback addressed (PR #123)
        D-->>U: Fixes complete
        deactivate D
    end
    
    U->>N: Check notifications
    U->>Q: Re-test PR #123
    Q->>Q: Validate fixes
    Q->>N: Write: 🟢 FYI - QA approved PR #123
    
    U->>R: Re-review PR #123
    R->>R: Re-review changes
    R->>N: Write: 🟢 FYI - Code review approved PR #123
    
    U->>D: Merge PR #123
    D->>D: Merge PR
    D->>FS: Update tasks.json (completed)
    D->>N: Write: 🟢 FYI - Merged PR #123
```

## 3. Notification Priority System

```mermaid
flowchart LR
    subgraph "Notification Board (notifications.md)"
        direction TB
        URG["🔴 URGENT<br/>Critical bugs<br/>Build failures<br/>Blockers<br/>Production issues"]
        IMP["🟡 IMPORTANT<br/>Features ready for QA<br/>PRs for review<br/>Architectural decisions<br/>Refactoring complete"]
        FYI["🟢 FYI<br/>Task completions<br/>Merged PRs<br/>General updates<br/>Tips & findings"]
    end
    
    subgraph "User-Mediated Workflow"
        USER["User checks<br/>notifications.md<br/>periodically"]
        ASSIGN["User assigns tasks<br/>to relevant roles"]
        DIRECT["User directs role:<br/>'Check notifications<br/>and respond'"]
    end
    
    URG --> USER
    IMP --> USER
    FYI --> USER
    
    USER --> ASSIGN
    USER --> DIRECT
    
    ASSIGN --> ROLE["Role executes<br/>assigned work"]
    DIRECT --> READ["Role reads<br/>notifications.md"]
    
    READ --> ACT["Role takes<br/>appropriate action"]
    ROLE --> POST["Role posts update<br/>to notifications.md"]
    ACT --> POST
    
    POST --> URG & IMP & FYI
    
    style URG fill:#ff6b6b,stroke:#c92a2a,stroke-width:3px,color:#fff
    style IMP fill:#ffd93d,stroke:#f3a712,stroke-width:2px
    style FYI fill:#6bcf7f,stroke:#37b551,stroke-width:2px
    style USER fill:#95e1d3,stroke:#38a3a5,stroke-width:3px
```

## 4. Cross-Role Collaboration Patterns

```mermaid
flowchart TD
    subgraph "Architect Role"
        A1[Design Architecture]
        A2[Review Tech Decisions]
        A3[Propose Improvements]
    end
    
    subgraph "Developer Role"
        D1[Implement Features]
        D2[Fix Bugs]
        D3[Create PRs]
    end
    
    subgraph "QA Engineer Role"
        Q1[Test Features]
        Q2[Report Bugs]
        Q3[Validate Fixes]
    end
    
    subgraph "Code Reviewer Role"
        R1[Review PRs]
        R2[Identify Issues]
        R3[Approve/Request Changes]
    end
    
    USER{{"User/Facilitator<br/>(Coordinates Communication)"}}
    NB{{"notifications.md<br/>(Message Board)"}}
    
    A1 -->|Write| NB
    USER -.->|Views & Assigns| NB
    USER -->|"Tell Developer:<br/>Check notifications"| D1
    
    D3 -->|Write| NB
    USER -.->|Views| NB
    USER -->|"Tell QA & Reviewer:<br/>Check & respond"| Q1
    USER -->|Direct| R1
    
    Q2 -->|Write| NB
    R2 -->|Write| NB
    USER -.->|Views| NB
    USER -->|"Tell Developer:<br/>Fix these issues"| D2
    
    D2 -->|Write| NB
    USER -.->|Views| NB
    USER -->|"Tell QA & Reviewer:<br/>Validate fixes"| Q3
    USER -->|Direct| R3
    
    Q3 -->|Write| NB
    R3 -->|Write| NB
    
    D1 -->|Ask Question| NB
    USER -.->|Sees question| NB
    USER -->|"Tell Architect:<br/>Answer this"| A2
    A2 -->|Write Answer| NB
    
    Q2 -.->|Pattern noticed| USER
    USER -->|Ask Architect| A3
    A3 -.->|Propose solution| USER
    USER -->|Direct| D1
    
    style NB fill:#ff6b6b,stroke:#c92a2a,stroke-width:4px,color:#fff
    style USER fill:#95e1d3,stroke:#38a3a5,stroke-width:4px
```

## 5. File System Structure & Data Flow

```mermaid
graph TB
    ROOT[".standup/ Directory"]
    
    ROOT --> NB["📢 notifications.md<br/>(Central Message Board)"]
    
    ROOT --> ARCH_DIR["📁 architect/"]
    ROOT --> DEV_DIR["📁 developer/"]
    ROOT --> QA_DIR["📁 qa-engineer/"]
    ROOT --> REV_DIR["📁 code-reviewer/"]
    
    ARCH_DIR --> ARCH_LOG["📄 log-2026-02-12.md<br/>(Daily narrative)"]
    ARCH_DIR --> ARCH_TASK["📋 tasks.json<br/>(Task tracking)"]
    ARCH_DIR --> ARCH_SUM["📊 session-summary-*.md"]
    
    DEV_DIR --> DEV_LOG["📄 log-2026-02-12.md"]
    DEV_DIR --> DEV_TASK["📋 tasks.json"]
    DEV_DIR --> DEV_SUM["📊 session-summary-*.md"]
    
    QA_DIR --> QA_LOG["📄 log-2026-02-12.md"]
    QA_DIR --> QA_TASK["📋 tasks.json"]
    QA_DIR --> QA_SUM["📊 session-summary-*.md"]
    
    REV_DIR --> REV_LOG["📄 log-2026-02-12.md"]
    REV_DIR --> REV_TASK["📋 tasks.json"]
    REV_DIR --> REV_SUM["📊 session-summary-*.md"]
    
    USER["👤 User/Facilitator"]
    
    subgraph "User-Mediated Read/Write"
        RW1["User monitors<br/>notifications.md"]
        RW2["User tells roles<br/>to check & respond"]
        RW3["Roles read when<br/>instructed by user"]
        RW4["Roles write<br/>when completing work"]
    end
    
    USER -.->|Monitors| NB
    NB -.-> RW1
    RW1 --> RW2
    RW2 --> RW3
    RW3 -.-> ARCH_LOG & DEV_LOG & QA_LOG & REV_LOG
    RW4 -.->|Posts to| NB
    
    style NB fill:#ff6b6b,stroke:#c92a2a,stroke-width:3px,color:#fff
    style ROOT fill:#4ecdc4,stroke:#0a9396,stroke-width:2px
    style USER fill:#95e1d3,stroke:#38a3a5,stroke-width:3px
```

## 6. Session Lifecycle State Machine

```mermaid
stateDiagram-v2
    [*] --> Initialization
    
    Initialization --> MorningStandup : All roles started
    
    MorningStandup --> WaitingForUserInput : Standup complete
    
    WaitingForUserInput --> ActiveWork : User assigns task
    
    ActiveWork --> WaitingForUserInput : Task complete, waiting
    
    WaitingForUserInput --> CheckingNotifications : User says "check notifications"
    
    CheckingNotifications --> RespondingToNotification : Found relevant message
    CheckingNotifications --> WaitingForUserInput : Nothing relevant
    
    RespondingToNotification --> WaitingForUserInput : Response posted
    
    WaitingForUserInput --> SessionShutdown : User ends session
    
    SessionShutdown --> GeneratingSummary : Shutdown initiated
    
    GeneratingSummary --> [*] : Summary saved
    
    note right of WaitingForUserInput
        Roles are PASSIVE
        They wait for user commands
        No autonomous polling
    end note
    
    note right of CheckingNotifications
        User explicitly instructs:
        "Check notifications.md
        and respond to anything
        relevant to your role"
    end note
```

---

## Key Insights

### **Actual Communication Model:**

✅ **User-Mediated** - User acts as the coordinator between roles  
✅ **Passive Sessions** - Roles wait for user input, no autonomous behavior  
✅ **Shared File Board** - `notifications.md` is the central message board  
✅ **Explicit Instructions** - User tells roles when to check notifications  
✅ **Transparent** - All communication is logged in plain text  
✅ **Git-Friendly** - Entire communication history is version controlled  

### **How It Actually Works:**

1. **File-Based Message Board** - `notifications.md` acts as a shared bulletin board
2. **User Coordination** - User monitors notifications and directs roles
3. **Priority System** - 🔴 URGENT, 🟡 IMPORTANT, 🟢 FYI help user prioritize
4. **Structured State** - Each role maintains `tasks.json` and daily logs
5. **Tmux Grid** - Visual layout shows all roles simultaneously
6. **Static Sessions** - Roles only act when user gives them instructions

### **User Workflow Example:**

```
1. User checks notifications.md
2. User sees: "🟡 IMPORTANT - Developer: Feature complete (PR #123)"
3. User tells QA: "Check notifications and test PR #123"
4. QA reads notifications, tests feature, posts results
5. User checks notifications again, sees QA found bugs
6. User tells Developer: "Check notifications and fix the bugs QA found"
7. Repeat cycle...
```
