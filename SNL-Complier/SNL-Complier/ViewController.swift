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
    var PredictSet = [Int : Set<String>]()
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var TextView: UITextView!
    
    @IBAction func Button1(_ sender: UIButton) {
        TextView.text = introductionText
    }
    
    @IBAction func Button2(_ sender: UIButton) {
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
        TextView.text = codes
    }
    
    @IBAction func Button3(_ sender: UIButton) {
        let lex = LexcialAnalyzer()
        lex.scan(codes)
        Tokens = lex.showTokens()
        tempText = "\(MyTools.showTable(text: "TYPE"))\(MyTools.showTable(text: "DATA"))\(MyTools.showTable(text: "LINE"))COLUMN\n"
        for token in Tokens {
            tempText += "\(MyTools.showTable(text: token.type.rawValue))"
            tempText += "\(MyTools.showTable(text: token.data))"
            tempText += "\(MyTools.showTable(text: String(token.line)))"
            tempText += "\(token.column)\n"
        }
        TextView.text = tempText
    }
    
    @IBAction func Button4(_ sender: UIButton) {
        grammarRules = """
        Program         ::= ProgramHead DeclarePart ProgramBody .
        
        ProgramHead     ::= PROGRAM ProgramName
        ProgramName     ::= ID

        DeclarePart     ::= TypeDecpart VarDecpart ProcDecpart
        
        TypeDecpart     ::= ε
                        |   TypeDec
        TypeDec         ::= TYPE TypeDecList
        TypeDecList     ::= TypeId = TypeDef ; TypeDecMore
        TypeDecMore     ::= ε
                        |   TypeDecList
        TypeId          ::= ID
        
        TypeDef         ::= BaseType
                        |   StructureType
                        |   ID
        BaseType        ::= INTEGER
                        |   CHAR
        StructureType   ::= ArrayType
                        |   RecType
        ArrayType       ::= ARRAY [ low .. top ] OF BaseType
        Low             ::= INTC
        Top             ::= INTC
        RecType         ::= RECORD FieldDecList END
        FieldDecList    ::= BaseType IdList ; FieldDecMore
                        |   ArrayType IdList ; FieldDecMore
        FieldDecMore    ::= ε
                        |   FieldDecList
        IdList          ::= ID IdMore
        IdMore          ::= ε
                        |   , IdList

        VarDecpart      ::= ε
                        |   VarDec
        VarDec          ::= VAR VarDecList
        VarDecList      ::= TypeDef VarIdList ; VarDecMore
        VarDecMore      ::= ε
                        |   VarDecList
        VarIdList       ::= ID VarIdMore
        VarIdMore       ::= ε
                        |   , VarIdList
        
        ProcDecpart     ::= ε
                        |   ProcDec
        ProcDec         ::= PROCEDURE ProcName ( ParamList ) ; ProcDecPart ProcBody ProcDecMore
        ProcDecMore     ::= ε
                        |   ProcDec
        ProcName        ::= ID
        
        ParamList       ::= ε
                        |   ParamDecList
        ParamDecList    ::= Param ParamMore
        ParamMore       ::= ε
                        |   ; ParamDecList
        Param           ::= TypeDef FormList
                        |   VAR TypeDef FormList
        FormList        ::= ID FidMore
        FidMore         ::= ε
                        |   , FormList
        
        ProcDecPart     ::= DeclarePart
        
        ProcBody        ::= ProgramBody
        
        ProgramBody     ::= BEGIN StmList END
        
        StmList         ::= Stm StmMore
        StmMore         ::= ε
                        |   ; StmList
        
        Stm             ::= ConditionalStm
                        |   LoopStm
                        |   InputStm
                        |   OutputStm
                        |   ReturnStm
                        |   ID AssCall
        
        AssCall         ::= AssignmentRest
                        |   CallStmRest
        
        AssignmentRest  ::= VariMore := Exp
        
        ConditionalStm  ::= IF RelExp THEN StmList ELSE StmList FI
        LoopStm         ::= WHILE RelExp DO StmList ENDWH
        InputStm        ::= READ ( Invar )
        Invar           ::= ID
        OutputStm       ::= WRITE ( Exp )
        ReturnStm       ::= RETURN
        
        CallStmRest     ::= ( ActParamList )
        ActParamList    ::= ε
                        |   Exp ActParamMore
        ActParamMore    ::= ε
                        |   , ActParamList
        
        RelExp          ::= Exp OtherRelE
        OtherRelE       ::= CmpOp Exp
        
        Exp             ::= Term OtherTerm
        OtherTerm       ::= ε
                        |   AddOp Exp
        
        Term            ::= Factor OtherFactor
        OtherFactor     ::= ε
                        |   MultOp Term
        
        Factor          ::= ( Exp )
                        |   INTC
                        |   Variable
        Variable        ::= ID VariMore
        VariMore        ::= ε
                        |   [ Exp ]
                        |   . FieldVar
        FieldVar        ::= ID FieldVarMore
        FieldVarMore    ::= ε
                        |   [ Exp ]
        
        CmpOp           ::= <
                        |   =
        
        AddOp           ::= +
                        |   -
        
        MultOp          ::= *
                        |   /
        """
        TextView.text = grammarRules
    }
    
    @IBAction func Button5(_ sender: UIButton) {
        let predictCalculation = PredictSetCalculation.init(text: grammarRules)
        ProductionList = predictCalculation.showProductionList()
        PredictSet = predictCalculation.showPredictSet()
        
        tempText = "ID\t\(MyTools.showTable(text: "PRODUCTION"))PREDICTSET\n"
        for (i,predict) in PredictSet.sorted(by: {$0.0 < $1.0}).enumerated() {
            tempText += "\(i+1):\t"
            tempText += "\(ProductionList[i].productionLeft)->"
            tempText += "\(ProductionList[i].productionRight)\t"
            tempText += "\(predict.value)\n"
        }
        TextView.text = tempText
    }
    
    @IBAction func Button6(_ sender: UIButton) {
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
        - 单字符分界符：\t\t( + , - , * , / , < ,= ,( , ) , [ , ] , . , ; , EOF ,空白字符 )
        - 双字符分界符：\t\t( := )
        - 注释头符：\t\t\t( { )
        - 注释结束符：\t\t( } )
        - 字符起始和结束符：\t( ‘ )
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
        TextView.text = introductionText
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.ScrollView.layoutIfNeeded()
        self.ScrollView.contentSize = self.TextView.bounds.size
    }
}

