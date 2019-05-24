//
//  ViewController.swift
//  SNL-Complier
//
//  Created by 陆子旭 on 2019/5/8.
//  Copyright © 2019 陆子旭. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var introductionText = ""
    var codes = ""
    var grammarRules = ""
    var tempText = ""
    var Tokens = [Token]()
    var ProductionList = [Production]()
    var LLTable = [[Int]]()
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var TextView: UITextView!
    
    @IBAction func Button1(_ sender: UIButton) {
        TextView.text = introductionText
    }
    
    @IBAction func Button2(_ sender: UIButton) {
        TextView.text = codes
    }
    
    @IBAction func Button3(_ sender: UIButton) {
        let lexcialAnalyzer = LexcialAnalyzer()
        lexcialAnalyzer.scan(codes: codes)
        Tokens = lexcialAnalyzer.showTokens()
        var table = TextTable.init(columns: [TextTableColumn(header: "TYPE"), TextTableColumn(header: "DATA"),TextTableColumn(header: "LINE"),TextTableColumn(header: "COLUMN")])
        for token in Tokens {
            table.addRow(values: [token.type.rawValue, token.data, String(token.line), String(token.column)])
        }
        tempText = table.render()
        TextView.text = tempText
    }
    
    @IBAction func Button4(_ sender: UIButton) {
        TextView.text = grammarRules
    }
    
    @IBAction func Button5(_ sender: UIButton) {
        let predictCalculation = PredictSetCalculation.init(text: grammarRules)
        ProductionList = predictCalculation.showProductionList()
        LLTable = predictCalculation.showTable()
        var ttCs = [TextTableColumn]()
        ttCs.append(TextTableColumn(header: ""))
        for t in TerminalType.allCases {
            ttCs.append(TextTableColumn(header: t.rawValue))
        }
        var table = TextTable.init(columns: ttCs)
        for (i, line) in LLTable.enumerated() {
            var lineword = [String]()
            lineword.append(NonTerminalType.allCases[i].rawValue)
            for word in line {
                lineword.append(String(word))
            }
            table.addRow(values: lineword)
        }
        tempText = table.render()
        TextView.text = tempText
    }
    
    @IBAction func Button6(_ sender: UIButton) {
        let syntaxParser = SyntaxParser.init(Tokens: Tokens, ProductionList: ProductionList, LLTable: LLTable)
        tempText = syntaxParser.showTree()
        TextView.text = tempText
    }
    
    @IBAction func Button7(_ sender: UIButton) {
    }
    
    @IBAction func Button8(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TextView.sizeThatFits(CGSize.init(width: TextView.frame.size.width, height: TextView.frame.size.height))
        introductionText = """
        SNL(Small Nested Language)语言是我们自行定义的教学模型语言，它是一种类PASCAL的“高级”程序设计语言。
        SNL语言的数据结构比较丰富，除了整型、字符型等简单数据类型外，还有数组、记录等结构数据类型，过程允许嵌套定义，允许递归调用。
        SNL语言基本上包含了高级程序设计语言的所有常用的成分，具备了高级程序设计语言的基本特征，实现SNL的编译器，
        可以涉及到绝大多数编译技术。通过对SNL语言编译程序的学习，我们可以更加深入更加全面的掌握编译程序的构造原理。
        但为了教学方便起见，略去了高级程序设计语言的一些复杂成分，如文件、集合、指针的操作等。
        
        
        SNL编译系统的单词符号分类如下：
        - 标识符：\t\t\t( ID )
        - 保留字：\t\t\t(它是标识符的子集, if,repeat,read,write，…)
        - 无符号整数：\t\t( INTC )
        - 单字符分界符：\t( + , - , * , / , < ,= ,( , ) , [ , ] , . , ; , EOF ,空白字符 )
        - 双字符分界符：\t( := )
        - 注释头符：\t\t( { )
        - 注释结束符：\t\t( } )
        - 字符起始和结束符：( ‘ )
        - 数组下标界限符：\t( .. )
        
        
        语法的非形式说明：
        一个SNL程序是由程序头、声明部分和程序体组成的。
        声明部分包括类型声明、变量声明和过程声明。
        SNL语言的语法规定可以声明整型（integer）、字符类型（char）、数组类型以及记录类型的类型标识符和变量。
        过程声明包括过程头、过程内部声明和过程体部分，过程声明内部还可以嵌套声明内层过程。
        程序体由语句序列构成，语句包括空语句、赋值语句、条件语句、循环语句、输入输出语句、过程调用语句和返回语句。
        表达式分为简单算术表达式和关系表达式。
        
        1．程序头的形式是：\t\t关键字program 后面跟着程序名标识符；
        2．类型定义的形式是：\t类型名标识符=类型定义，其中类型定义可以是类型名或者是结构类型定义，类型名可以是基本类型，
        \t\t\t\t\t\t或者是前面已经定义的一个类型标识符；
        3．变量声明的形式是：\t类型名后面跟着用逗号隔开的变量标识符序列；
        4．过程声明的形式是：\t关键字procedure跟着过程名标识符，以及参数声明、类型定义、变量说明、内层过程声明和程序体；
        5．程序体的形式是：\t\t以关键字begin开头，关键字end结尾，中间是用分号隔开的语句序列（注意最后一条语句后不加分号），
        \t\t\t\t\t\t最后用“.”标志程序体的结束。
        """
        
        codes = """
        {实现冒泡排序算法的SNL程序}
        program bubble
            var integer i,j,num;
            array [1..20] of integer a;
        
            procedure q(integer num);
                var integer i,j,k;
                integer t;
                begin
                    i := 1;
                    while i < num do
                        j := num - i + 1;
                        k := 1;
                        while k < j do
                            if a[k + 1] < a[k]
                            then
                                t := a[k];
                                a[k] := a[k + 1];
                                a[k + 1] := t
                            else
                                temp := 0
                            fi;
                            k := k+1
                        endwh;
                        i := i+1
                    endwh
                end
        
            begin
                read(num);
                i := 1;
                while i < (num + 1) do
                    read(j);
                    a[i] := j;
                    i := i + 1
                endwh;
                q(num);
                i := 1;
                while i < (num + 1) do
                    write(a[i]);
                    i := i + 1
                endwh
            end.
        """
        
        grammarRules = """
        Program         ::= ProgramHead DeclarePart ProgramBody DOT
        
        ProgramHead     ::= PROGRAM ProgramName
        ProgramName     ::= ID
        
        DeclarePart     ::= TypeDec VarDec ProcDec
        
        TypeDec         ::= ε
        |   TypeDeclaration
        TypeDeclaration ::= TYPE TypeDecList
        TypeDecList     ::= TypeId EQ TypeName SEMI TypeDecMore
        TypeDecMore     ::= ε
        |   TypeDecList
        TypeId          ::= ID
        
        TypeName        ::= BaseType
        |   StructureType
        |   ID
        BaseType        ::= INTEGER
        |   CHAR
        StructureType   ::= ArrayType
        |   RecType
        ArrayType       ::= ARRAY LMIDPAREN Low UNDERANGE Top RMIDPAREN OF BaseType
        Low             ::= INTC
        Top             ::= INTC
        RecType         ::= RECORD FieldDecList END
        FieldDecList    ::= BaseType IdList SEMI FieldDecMore
        |   ArrayType IdList SEMI FieldDecMore
        FieldDecMore    ::= ε
        |   FieldDecList
        IdList          ::= ID IdMore
        IdMore          ::= ε
        |   COMMA IdList
        
        VarDec          ::= ε
        |   VarDeclaration
        VarDeclaration  ::= VAR VarDecList
        VarDecList      ::= TypeName VarIdList SEMI VarDecMore
        VarDecMore      ::= ε
        |   VarDecList
        VarIdList       ::= ID VarIdMore
        VarIdMore       ::= ε
        |   COMMA VarIdList
        
        ProcDec         ::= ε
        |   ProcDeclaration
        ProcDeclaration ::= PROCEDURE ProcName LPAREN ParamList RPAREN SEMI ProcDecPart ProcBody ProcDecMore
        ProcDecMore     ::= ε
        |   ProcDeclaration
        ProcName        ::= ID
        
        ParamList       ::= ε
        |   ParamDecList
        ParamDecList    ::= Param ParamMore
        ParamMore       ::= ε
        |   SEMI ParamDecList
        Param           ::= TypeName FormList
        |   VAR TypeName FormList
        FormList        ::= ID FidMore
        FidMore         ::= ε
        |   COMMA FormList
        
        ProcDecPart     ::= DeclarePart
        
        ProcBody        ::= ProgramBody
        
        ProgramBody     ::= BEGIN StmList END
        
        StmList         ::= Stm StmMore
        StmMore         ::= ε
        |   SEMI StmList
        
        Stm             ::= ConditionalStm
        |   LoopStm
        |   InputStm
        |   OutputStm
        |   ReturnStm
        |   ID AssCall
        
        AssCall         ::= AssignmentRest
        |   CallStmRest
        
        AssignmentRest  ::= VariMore ASSIGN Exp
        
        ConditionalStm  ::= IF RelExp THEN StmList ELSE StmList FI
        LoopStm         ::= WHILE RelExp DO StmList ENDWH
        InputStm        ::= READ LPAREN Invar RPAREN
        Invar           ::= ID
        OutputStm       ::= WRITE LPAREN Exp RPAREN
        ReturnStm       ::= RETURN LPAREN Exp RPAREN
        
        CallStmRest     ::= LPAREN ActParamList RPAREN
        ActParamList    ::= ε
        |   Exp ActParamMore
        ActParamMore    ::= ε
        |   COMMA ActParamList
        
        RelExp          ::= Exp OtherRelE
        OtherRelE       ::= CmpOp Exp
        
        Exp             ::= Term OtherTerm
        OtherTerm       ::= ε
        |   AddOp Exp
        
        Term            ::= Factor OtherFactor
        OtherFactor     ::= ε
        |   MultOp Term
        
        Factor          ::= LPAREN Exp RPAREN
        |   INTC
        |   Variable
        Variable        ::= ID VariMore
        VariMore        ::= ε
        |   LMIDPAREN Exp RMIDPAREN
        |   DOT FieldVar
        FieldVar        ::= ID FieldVarMore
        FieldVarMore    ::= ε
        |   LMIDPAREN Exp RMIDPAREN
        
        CmpOp           ::= LT
        |   EQ
        
        AddOp           ::= PLUS
        |   MINUS
        
        MultOp          ::= TIMES
        |   OVER
        """
        
        let lexcialAnalyzer = LexcialAnalyzer()
        lexcialAnalyzer.scan(codes: codes)
        Tokens = lexcialAnalyzer.showTokens()
        let predictCalculation = PredictSetCalculation.init(text: grammarRules)
        ProductionList = predictCalculation.showProductionList()
        LLTable = predictCalculation.showTable()
        
        TextView.text = introductionText
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.ScrollView.layoutIfNeeded()
        self.ScrollView.contentSize = self.TextView.bounds.size
    }
}
