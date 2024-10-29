import 'budget.dart';

class Tip {
  String tip = ''; // Holds the generated tip

  Tip(this.tip);

  // Method to generate tips based on the mood/profile
  String displayTip(String category, Budget budget) {
    if (budget.mood == 'Captain Saver') {
      if (category == 'Savings') {
        tip = "أنت بطل التوفير! ادخر قدر ما تستطيع لتحقيق أحلامك المستقبلية!";
      } else if (category == 'Food & Snacks') {
        tip = "حاول تقليل مصروفك على الطعام لتوفير المزيد للمستقبل";
      } else if (category == 'Entertainment') {
        tip = "استمتع بوقتك، لكن تذكر أن تدخر جزءًا من مصروفك!";
      } else if (category == 'Needs') {
        tip = "ركز على الحاجات الضرورية فقط، حتى تتمكن من ادخار الباقي";
      }
    } else if (budget.mood == 'Captain Balanced') {
      if (category == 'Savings') {
        tip = "توازن رائع! استمر في ادخار جزء من مصروفك";
      } else if (category == 'Food & Snacks') {
        tip = "احرص على توزيع مصروفك للطعام بشكل متوازن!";
      } else if (category == 'Entertainment') {
        tip = "استمتع بوقتك، وخصص ميزانية للترفيه مع مراعاة التوازن";
      } else if (category == 'Needs') {
        tip = "استمر في تلبية احتياجاتك الأساسية بميزانية مناسبة";
      }
    } else if (budget.mood == 'Captain Funster') {
      if (category == 'Entertainment') {
        tip = "استمتع بوقتك! خصص ميزانية كافية للترفيه واستمتع بكل لحظة";
      } else if (category == 'Food & Snacks') {
        tip = "تناول وجباتك الخفيفة المفضلة، ولكن لا تنسَ تخصيص مبلغ للتوفير";
      } else if (category == 'Savings') {
        tip = "ادخر قليلاً حتى تتمكن من الاستمتاع بوقتك بدون قلق";
      } else if (category == 'Needs') {
        tip = "تأكد من تلبية الحاجات الأساسية قبل التركيز على الترفيه";
      }
    } else if (budget.mood == 'Captain Essential') {
      if (category == 'Needs') {
        tip = " ركز على تلبية احتياجاتك الأساسية أولاً";
      } else if (category == 'Food & Snacks') {
        tip = "احرص على شراء الطعام الضروري فقط، وقلل من النفقات غير الضرورية";
      } else if (category == 'Entertainment') {
        tip = "اجعل الترفيه بسيطاً حتى تتمكن من تلبية احتياجاتك الأساسية";
      } else if (category == 'Savings') {
        tip = "ادخر ما تستطيع للمستقبل وركز على الأولويات";
      }
    } else if (budget.mood == 'Captain Foodie') {
      if (category == 'Food & Snacks') {
        tip = "أنت محب للطعام! استمتع بوجباتك ولكن بميزانية مناسبة";
      } else if (category == 'Entertainment') {
        tip = "استمتع بوقتك، لكن تذكر أن تترك جزءًا أكبر للطعام!";
      } else if (category == 'Savings') {
        tip = "ادخر ما تستطيع حتى تتمكن من تناول وجباتك المفضلة مستقبلاً";
      } else if (category == 'Needs') {
        tip = "احرص على تلبية احتياجاتك الأساسية بجانب الاستمتاع بوجباتك";
      }
    } 
    return tip;
  }
}
