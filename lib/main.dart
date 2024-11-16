import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kalkulator iPhone',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget{ //class calculator adalah widget stateful karena memiliki nilai yang selalu berubah ketika tombolnya ditekan
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String output = "0"; //output merupakan variabel yang menampung nilai yang akan ditampilkan di kalkulator
  void buttonPressed(String buttonText){ //fungsi buttonpressed yang akan dipanggil ketika tombol ditekan
    setState(() {
      if (buttonText == "C") { //jika tombol c ditekan, output diubah menjadi 0
        output = "0";
      } else if (buttonText == "=") { //jika tombol = ditekan, output diubah menjadi hasil dari expression
        try {
          output = evaluateExpression(output.replaceAll("x", "*").replaceAll("÷", "/")); // evaluateExpression adalah fungsi yang digunakan untuk menghitung hasil dari  expression
        } catch (e){ //catch digunakan untuk menangani kesalahan yang terjadi ketika menghitung expression (contohnya jika user memasukkan fungsi yang tidak valid seperti 1++2 atau hanya +)
          output = "Error"; //jika terjadi kesalahan, output yang muncul di kalkulator diubah menjadi Error
        }
      } else {
        if (output == "0") {
          output = buttonText;
        } else {
          output += buttonText;
        }
      }
    });
  }
  String evaluateExpression(String expression){ //fungsi ini digunakan untuk mengonversi expression menjadi hasil perhitungan.fungsi ini diambil dari expression.dart
    final parsedExpression = Expression.parse(expression); // digunakan untuk mengonversi string menjadi expression yang dapat dipahami oleh komputer
    final evaluator = ExpressionEvaluator(); // + - * / atau operasi aritmatika masuk ke evaluator
    final result = evaluator.eval(parsedExpression, {}); // digunakan untuk mengecaluasi expression dan mengembalikan nilai sebagai string
    return result.toString(); //pengembalian nilai kepada string
  }
  Widget buildButton(String buttonText, Color color, {double widthFactor = 1.0}){ //fungsi ini digunakan untuk membuat widget tombol dengan teks, warna, dan ukuran yang sudah ditentukan
    return Expanded( //membuat tombol dapat mengisi ruang horizontal yang tersedia dalam 1 baris atau 1 row
      flex: widthFactor.toInt(), //widthfactor digunakan untuk menentukan lebar tombol menjadi 1. flex digunakan untuk menentukan proporsi lebar tombol dalam baris
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton( //digunakan untuk membuat tombol dengan gaya tertentu
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 22), //digunakan untuk mengatur jarak dalam tombol secara vertical menjadi 22 sehingga tombol terlihat tinggi
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0), //digunakan untuk membuat sudut tombol melengkung dengan radius 40
            ),
            elevation: 0, //mengatur bayangan tombol menjadi 0 dan tampak datar
          ),
          onPressed: () => buttonPressed(buttonText), //ketika ditekan, fungsi button Pressed dipanggil dengan parameter buttonText
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){//fungsi build digunakan untuk membuat tampilan utama
    return Scaffold(//digunakan untuk membuat struktur dasar untuk halaman
    body:  Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, //tanpa CrossAxisAligment.strech, tombol - tombol tersebut akan memiliki lebar sesuai dengan ukuran teksnya masing masing atau pengaturan default widget tombol
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.only(right: 24, bottom: 24),
            alignment: Alignment.bottomRight,
            child: Text(
              output,
              style: TextStyle(
                fontSize: 80,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                buildButton("C", Colors.grey.shade600),
                buildButton("+/-", Colors.grey.shade600),
                buildButton("%", Colors.grey.shade600),
                buildButton("÷", Colors.orange),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton("7", Colors.grey.shade800),
                buildButton("8", Colors.grey.shade800),
                buildButton("9", Colors.grey.shade800),
                buildButton("x", Colors.orange),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton("4", Colors.grey.shade800),
                buildButton("5", Colors.grey.shade800),
                buildButton("6", Colors.grey.shade800),
                buildButton("-", Colors.orange),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton("1", Colors.grey.shade800),
                buildButton("2", Colors.grey.shade800),
                buildButton("3", Colors.grey.shade800),
                buildButton("+", Colors.orange),
              ],
            ),
            Row(
              children: <Widget>[
                buildButton("0", Colors.grey.shade800, widthFactor: 2), //widthfactor digunakan untuk mengatur lebar tombol menjadi 2
                buildButton(".", Colors.grey.shade800),
                buildButton("=", Colors.orange),
              ],
            )
          ],
        )
      ],
    ),
  );
  }
}
