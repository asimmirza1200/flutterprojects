import 'package:flutter/material.dart';
import 'package:lesson_flutter/api/index.dart';
import 'package:lesson_flutter/models/MediaGroup.dart';
import 'package:lesson_flutter/models/MediaItems/Book.dart';
import 'package:lesson_flutter/models/MediaItems/Video.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/toast.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class BookActivity extends StatefulWidget {
  final List books;

  BookActivity({this.books});

  @override
  _BookActivityState createState() => _BookActivityState();
}

class _BookActivityState extends State<BookActivity> {
  PDFDocument doc;

  @override
  void initState() {
    super.initState();
  }

  Future<PDFDocument> getBookPdf() async {
    try {
      print(this
          .widget
          .books
          .where((element) => element.name.contains("Text"))
          .first
          .name);
      Map booksMap = await Book.getBooksFromList(this.widget.books);
      List booksArray = booksMap["data"];
      print(booksArray);
      List<Book> books = booksArray.map((item) => Book.fromJson(item)).toList();
      String bookLocal = books[0].local ?? books[0].url;
      PDFDocument doc = await PDFDocument.fromURL(
          ApiHandler.getMediaUrl(bookLocal, "books", "school"));
      return doc;
    } catch (e) {
      doAlert(message: "Something went wrong");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: FutureBuilder(
          future: getBookPdf(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Loader(),
              );
            }
            if (snapshot.hasError) {
              return Container(
                child: Text("Something went wrong"),
              );
            }
            if (snapshot.hasData) {
              doc = snapshot.data;
              if (doc == null) {
                return Container(
                  child: Text("Something went wrong"),
                );
              }
              return Container(
                child: PDFViewer(
                  document: doc,
                  indicatorBackground: AppConstants.kBlueColor,
                ),
              );
            }
            return SizedBox();
          }),
    );
  }
}
