class Tip {

  String tip;
  Tip(this.tip);

  // Method to update the tip 
  void updateTip(String newTip) {
    tip = newTip;
  }

  // Method to display the tip based on the child's progress for each category
  void displayTip(String category, double currentAmount, double spentAmount) {
    if (category == 'Food & Snacks') {
      if (spentAmount <= currentAmount) {
        // Good progress tip
        print('أحسنت! أنت تدير نقودك بشكل جيد على الطعام والوجبات الخفيفة.');
      } else {
        // Bad progress tip
        print('حاول توفير جزء من مصروفك لشراء الطعام الصحي.');
      }

    } else if (category == 'Entertainment') {
      if (spentAmount <= currentAmount) {
        // Good progress tip
        print('رائع! أنت تدير إنفاقك على الترفيه بطريقة ذكية.');
      } else {
        // Bad progress tip
        print('حاول البحث عن أنشطة مجانية لتوفير المزيد من المال.');
      }

    } else if (category == 'Needs') {
      if (spentAmount <= currentAmount) {
        // Good progress tip
        print('جيد جداً! أنت تخصص ما يكفي من المال للأشياء الضرورية.');
      } else {
        // Bad progress tip
        print('كن حذراً في الإنفاق على الأشياء غير الضرورية.');
      }

    } else if (category == 'Savings') {
      if (spentAmount <= currentAmount) {
        // Good progress tip
        print('ممتاز! أنت تدخر بشكل منتظم. استمر على هذا النحو!');
      } else {
        // Bad progress tip
        print('ادخر مبلغ صغير كل يوم لضمان ادخار أكبر.');
      }

    } // End of DisplayTip method
  }
}
