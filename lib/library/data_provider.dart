// lib/services/data_provider.dart
import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  // بيانات المدن والمناطق
  final Map<String, List<String>> _citiesAndAreas = {
    'عمان': [
      'ابو السوس',
      'ابو النعير',
      'ابو علندا',
      'ابو نصير',
      'ارينبه الشرقية',
      'ارينبه الغربية',
      'الأمير حمزة',
      'الايمان',
      'البحاث',
      'البصة',
      'البقعه',
      'البنيات',
      'البيادر',
      'البيضاء',
      'الجاردنز',
      'الجبل الأخضر',
      'الجبيهة',
      'الجميل',
      'الجندويل',
      'الجويدة',
      'الجيزة',
      'الحرّيّة',
      'الحسنية',
      'الحمر',
      'الحمرانية',
      'الخريم',
      'الخشافية',
      'الخضراء',
      'الدمينا',
      'الدمينه',
      'الدوار الأول',
      'الدوار الثاني',
      'الدوار الثالث',
      'الدوار الرابع',
      'الدوار الخامس',
      'الدوار السادس',
      'الدوار السابع',
      'الدوار الثامن',
      'الديار',
      'الذراع',
      'الذهيبة',
      'الذهيبه الشرقيه',
      'الذهيبة الغربيه',
      'الرابية',
      'الربوة',
      'الرجوم',
      'الرجيب',
      'الرجيلة',
      'الرضوان',
      'الرقيم',
      'الروابي',
      'الرونق',
      'الزعفران',
      'الزميلة',
      'الزهراء',
      'الزيتونة',
      'السرو',
      'السهل',
      'الصناعة',
      'الصويفية',
      'الضياء',
      'الظهير',
      'العال',
      'العبْدلي',
      'العبْدلية',
      'العدلية',
      'العروبة',
      'العودة',
      'الفحيص',
      'الفروسية',
      'القسطل',
      'القصبات',
      'القصور',
      'القنيطره',
      'القويسمة',
      'الكتيفه',
      'الكرسي',
      'الكمالية',
      'الكوم الشرقي',
      'الكوم الغربي',
      'اللبّن',
      'الماضونة',
      'المحطة',
      'المدينة الرياضية',
      'المرقب',
      'المستندة',
      'المشتى',
      'المشقر',
      'المعادي',
      'المغيرات',
      'المقابلين',
      'المناره',
      'المنصور',
      'الموقر',
      'النقيرة',
      'النهارية',
      'الهاشمي الجنوبي',
      'الهاشمي الشمالي',
      'الوحدات',
      'اليادودة',
      'الياسمين',
      'اليرموك',
      'ام اذينة',
      'ام اذينة الشرقي',
      'ام اذينة الغربي',
      'أم الأسود',
      'ام البساتين',
      'ام الدنانير',
      'ام الرصاص',
      'ام السماق',
      'أم العمد',
      'أم الكندم',
      'ام بطمه',
      'أم رمانة',
      'ام زويتينة',
      'أم شطيرات',
      'أم قصير',
      'ام نوارة',
      'بدر',
      'بدر الجديدة',
      'بسمان',
      'بلال',
      'بيرين',
      'تلاع العلي',
      'تلاع العلي الشرقي',
      'تلاع العلي الشمالي',
      'جاوا',
      'جبل الأشرفية',
      'جبل التاج',
      'جبل الجوفة',
      'جبل الحسين',
      'جبل الزهور',
      'جبل اللويبدة',
      'جبل المريخ',
      'جبل النزهة',
      'جبل النصر',
      'جبل النظيف',
      'جبل عمان',
      'جلول',
      'حجار النوابلسة',
      'حسبان',
      'حطين',
      'حوارة',
      'حي البركة',
      'حي الخالدين',
      'حي الرحمانية',
      'حي الصالحين',
      'حي الصحابة',
      'حي عدن',
      'حي نزال',
      'خان الزبيب',
      'خربة السوق',
      'خلدا',
      'دابوق',
      'دير غبار',
      'راس العين',
      'رجم الشامي',
      'رجم الشوف',
      'رجم عميش',
      'زبود',
      'زملة العليا',
      'زويزا',
      'زينات الربوع',
      'زينب',
      'سالم',
      'سحاب',
      'شارع الأردن',
      'شارع الجامعة',
      'شارع المدينة',
      'شارع المية',
      'شارع مكة',
      'شفا بدران',
      'شميساني',
      'صافوط',
      'صالحية العابد',
      'صوفا',
      'صويلح',
      'ضاحية الاستقلال',
      'ضاحية الاقصى',
      'ضاحية الامير حسن',
      'ضاحية الامير راشد',
      'ضاحية الأمير علي',
      'ضاحية الحاج حسن',
      'ضاحية الحسين',
      'ضاحية الرشيد',
      'ضاحية الروضة',
      'ضاحية النخيل',
      'ضبعه',
      'طبربور',
      'طريق المطار',
      'طريق المطار - جسر ديونز',
      'طريق المطار - جسر مادبا',
      'طلوع المصدار',
      'عبدون',
      'عبدون الجنوبي',
      'عبدون الشمالي',
      'عراق الامير',
      'عرجان',
      'عين رباط',
      'عيون الذيب',
      'قعفور',
      'ماحص',
      'ماركا',
      'ماركا الجنوبية',
      'ماركا الشمالية',
      'مرج الحمام',
      'مرج الفرس',
      'موبص',
      'ناعور',
      'وادي الحدادة',
      'وادي السرور',
      'وادي السير',
      'وادي الطي',
      'وادي العش',
      'وادي صقرة',
      'وسط البلد',
      'ياجوز'
    ],
    'الزرقاء': [
      'حي الأمير عبدالله',
      'أبو الزيغان',
      'اتوستراد',
      'اسكان البتراوي',
      'اسكان طلال-الرصيفة',
      'الأزرق',
      'البستان',
      'التطوير الحضري',
      'التطوير الحضري-الرصيفة',
      'الثوره العربية الكبرى',
      'الرصيفة',
      'الرصيفة الجنوبي',
      'الزرقاء الجديدة',
      'الزواهرة',
      'السخنة',
      'الضليل',
      'الغباوي',
      'الغويرية',
      'القادسية-الرصيفة',
      'الكمشة',
      'المنطقة الحرة',
      'النصر',
      'الهاشمية',
      'أم رمانة',
      'أم صليح',
      'جامعة الزرقاء الخاصة',
      'جبل الأبيض',
      'جبل الأمير حسن',
      'جبل الأمير حمزة',
      'جبل الأمير فيصل',
      'جبل الاميرة رحمة',
      'جبل الشمالي-الرصيفة',
      'جبل المغير',
      'جبل طارق',
      'جريبا',
      'جناعة',
      'حي الاسكان',
      'حي الأمير محمد',
      'حي الجندي',
      'حي الحسين',
      'حي الرشيد-الرصيفة',
      'حي النزهة',
      'حي جعفر الطيار',
      'حي رمزي',
      'حي شاكر',
      'حي معصوم',
      'خو',
      'دوقرة',
      'رجم الشوك',
      'شارع الجيش',
      'شارع السعادة',
      'شارع المصفاة',
      'شومر',
      'صروت',
      'ضاحية الأميرة هيا',
      'ضاحية المدينة المنورة',
      'ضاحية مكة المكرمة',
      'قصر الحلابات الشرقي',
      'قصر الحلابات الغربي',
      'مخيم حطين',
      'مدينة الشرق',
      'وادي الحجر',
      'وادي العش'
    ],
    'إربد': [
      'ابان',
      'أبو سيدو',
      'اربد مول',
      'ارحابا',
      'اسكان الأطباء',
      'اسكان العاملين',
      'اسكان الضباط',
      'اسكان المهندسين',
      'اشارة الاسكان',
      'اشارة الدراوشة',
      'اشارة الملكة نور',
      'الأشرفية',
      'الباقورة',
      'البارحة',
      'البلد',
      'الحسبة المركزية',
      'الحصن',
      'الحي الجنوبي',
      'الحي الشرقي',
      'الحي الغربي',
      'الخراج',
      'الرابية',
      'الزمالية',
      'السنبلة',
      'السوق',
      'الشجرة',
      'الشونة الشمالية',
      'الشيخ حسين',
      'الصريح',
      'العدسية',
      'المخيبة التحتة',
      'المدرسة الشاملة',
      'المزار الشمالي',
      'المشارع',
      'المغير',
      'الملعب البلدي',
      'المنشية',
      'النزهة',
      'النعيمة',
      'ام الجدايل',
      'ام قيس',
      'ايدون',
      'برشتا',
      'بشرى',
      'بصيلة',
      'بيت أديس',
      'بيت راس',
      'بيت يافا',
      'تبنه',
      'تقبل',
      'ججين',
      'جحفية',
      'جمحا',
      'جيفين',
      'حبراص',
      'حبكا',
      'حدائق الملك عبدالله',
      'حرثا',
      'حريما',
      'حكمًا',
      'حنينا',
      'حوارة',
      'حور',
      'حوفا',
      'حي الأبرار',
      'حي الأفراح',
      'حي التركمان',
      'حي التلول',
      'حي الزهور',
      'حي القصيلة',
      'حي المنارة',
      'حي الورود',
      'حي طوال',
      'حي عالية',
      'خربة البرز',
      'خربة قاسم',
      'خرجا',
      'خلف السيفوي',
      'دوار البياضة',
      'دوار الثقافة',
      'دوار الدرة',
      'دوار العيادات',
      'دوار القبة',
      'دوار اللوازم',
      'دوار النسيم',
      'دوار سال',
      'دوار شركة الكهرباء',
      'دوار صحارى',
      'دوقرا',
      'دير أبي سعيد',
      'دير السعنة',
      'دير يوسف',
      'زبدة',
      'زهر',
      'زوبيا',
      'سال',
      'سحم',
      'سما الروسان',
      'سمر',
      'سموع',
      'سوم',
      'سيل الحمة',
      'شارع البارحة',
      'شارع البتراء',
      'شارع الثلاثين',
      'شارع الجامعة',
      'شارع الحصن',
      'شارع القدس',
      'شارع الهاشمي',
      'شارع حكما',
      'شارع فلسطين',
      'شارع فوعرة',
      'شطنا',
      'صالة الشرق',
      'صما',
      'صمد',
      'صيدور',
      'ضاحية الأمير راشد',
      'ضاحية الحسين',
      'طبقة فحل',
      'علعال',
      'عنبة',
      'فوعرا',
      'قراقوش',
      'قرية حاتم',
      'قرية صمد',
      'قم',
      'قميم',
      'كتم',
      'كريمة',
      'كفر ابيل',
      'كفر أسد',
      'كفر الماء',
      'كفر جايز',
      'كفر راكب',
      'كفر سوم',
      'كفر يوبا',
      'كفرعوان',
      'كلية بنات اربد',
      'لواء الطيبة',
      'مجمع الأغوار الجديد',
      'مجمع الشمال',
      'مجمع الشيخ خليل',
      'مجمع عمان الجديد',
      'مخربا',
      'مرو',
      'مستشفى الأميرة بسمة',
      'مستشفى الملك عبدالله',
      'مستشفى ايدون العسكري',
      'مسجد حسن التل',
      'ملكا',
      'مندح',
      'ناطفه',
      'هام',
      'وادي الريان',
      'وقاص',
      'يبلا'
    ],
    'السلط': [
      'البلقاء',
      'الجادور',
      'الجدعة',
      'الخضر',
      'الخندق',
      'الرميمين',
      'الزهور',
      'السلالم',
      'السليحي',
      'الشونه الجنوبيه',
      'الصبيحي',
      'الصوارفة',
      'العيزرية',
      'القلعة',
      'المغاريب',
      'المنشية',
      'أم جوزة',
      'جلعد',
      'حي الخرابشة',
      'دير علا',
      'زي',
      'سويمة',
      'شفا العامرية',
      'علان',
      'عيرا',
      'عين الباشا',
      'قرية أبو نصير',
      'كفرهودا',
      'نقب الدبور',
      'وادي شعيب',
      'يرقا'
    ],
    'مادبا': [
      'الامام العزالي',
      'الجبيل',
      'الزعفران',
      'الفحاء',
      'الفيصلية',
      'النزهة',
      'النصر',
      'جرينة',
      'جلول',
      'حنينا',
      'حنينا الغربيه',
      'دليله الحمايده',
      'ذيبان',
      'لب',
      'ماعين',
      'مخيم مادبا',
      'مكاور',
      'منجا',
      'وسط مادبا',
      'أم الدنانير'
    ],
    'العقبة': [
      'الأطباء',
      'البلد القديمة',
      'الحرفية',
      'الرضوان',
      'الرمال',
      'السكنية 10',
      'السكنية 3',
      'السكنية 5',
      'السكنية 6',
      'السكنية 7',
      'السكنية 8',
      'السكنية 9',
      'الشامية',
      'الشعبية',
      'العالمية',
      'القويرة',
      'الكرامة',
      'ايلة',
      'تالا باي',
      'سكن الأسمدة',
      'وادي رم'
    ],
    'المفرق': [
      'ارحاب',
      'البادية الشمالية',
      'البادية الشمالية الغربية',
      'الباعج',
      'البستان',
      'الحمراء',
      'الحي الجنوبي',
      'الحي الهاشمي',
      'الخالدية',
      'الخربة السمرا',
      'الدجنية',
      'الدفيانة',
      'الرشادة',
      'الرفاعيات',
      'الزعتري',
      'الزنية',
      'الزيتونة',
      'الصالحية',
      'الصفاوي',
      'الغدير الأبيض',
      'المبروكة',
      'المراجم',
      'المزة',
      'المنصورة',
      'النظامية',
      'أم الجمال',
      'أم القطين',
      'أم اللولو',
      'أم النعام الشرقية',
      'أم النعام الغربي',
      'أم بطيمة',
      'أم صويوينة',
      'ايدون',
      'بلعما',
      'بويضة الحوامدة',
      'بويضة العليمات',
      'ثغرة الجب',
      'حوشا',
      'حي الحسين',
      'حي الزهور',
      'حي الضباط',
      'حي نوارة',
      'حيان الرويبض',
      'حيان المشرف',
      'دحل',
      'دير الكهف',
      'رحبة ركاد',
      'رويشيد',
      'زملة الأمير غازي',
      'سما السرحان',
      'صبحا',
      'ضاحية الجامعة',
      'طيب اسم',
      'عين والمعمرية',
      'فاع',
      'كوم الأحمر',
      'مغير السرحان',
      'منشية بني حسن',
      'نادرة',
      'نايفه',
      'هويشان'
    ],
    'جرش': [
      'قرية نحلة',
      'الحدادة',
      'الرشايدة',
      'الكته',
      'المشيرفة',
      'المصطبة',
      'النسيم',
      'برما',
      'تل الرمان',
      'دبين',
      'ساكب',
      'سوف',
      'عمامه',
      'عنيبة',
      'قفقفا',
      'كفر خل'
    ],
    'الكرك': [
      'أدر',
      'الثنية',
      'الربة',
      'السميكية',
      'العدنانية',
      'القطرانة',
      'القصر',
      'المرج',
      'المزار الجنوبي',
      'المشيرفة',
      'ذات راس',
      'غور الصافي',
      'فقوع',
      'قصور بشير',
      'مؤتة',
      'منشية أبو حمور'
    ],
    'عجلون': [
      'البلد',
      'القلعة',
      'الهاشمية',
      'برقش',
      'عبين',
      'عنجرة',
      'عين جنا',
      'كفرنجا'
    ],
    'معان': [
      'البتراء',
      'البيضا',
      'الجاية',
      'الجفر',
      'الحسينية',
      'المريغة',
      'الشوبك',
      'أم صيحون',
      'أيل',
      'راس النقب',
      'سطح معان',
      'شماخ',
      'قصبة معان',
      'نجل',
      'وادي موسى'
    ],
    'الرمثا': [
      'البويضة',
      'الحي الغربي',
      'الذنيبة',
      'الرمثا',
      'الشجرة',
      'الطرة',
      'عمراوة'
    ],
    'الطفيلة': ['الحسا', 'الرشادية', 'القادسية', 'العيص', 'بصيرة'],
    'الغور': ['البحر الميت', 'الراما', 'المغطس', 'غور الكفرين', 'جرف الدراويش'],
  };

  // بيانات الفئات والمهن
  final Map<String, List<String>> _categoriesAndProfessions = {
    'الصيانة والإصلاحات المنزلية': [
      'كهربائي',
      'سباك',
      'فني تكييف وتبريد',
      'فني صيانة سخانات',
      'مصلح غسالات وثلاجات',
      'مصلح أفران ومواقد الغاز',
      'فني أجهزة منزلية'
    ],
    'البناء والتشطيبات': [
      'نجار',
      'حداد',
      'دهان (صباغ)',
      'عامل بناء',
      'معلم جبس بورد',
      'معلم بلاط وسيراميك',
      'مقاول بناء',
      'معلم رخام وجرانيت'
    ],
    'السيارات والمركبات': [
      'ميكانيكي سيارات',
      'كهربائي سيارات',
      'سمكري (حداد سيارات)',
      'فني دهان سيارات',
      'مبرمج مفاتيح السيارات',
      'فني تركيب إكسسوارات السيارات',
      'فني فحص سيارات'
    ],
    'الإلكترونيات والتقنية': [
      'فني صيانة هواتف',
      'فني صيانة كمبيوتر ولابتوب',
      'مبرمج أجهزة إلكترونية',
      'فني تركيب كاميرات مراقبة',
      'فني تركيب أنظمة إنذار',
      'فني صيانة أجهزة منزلية ذكية'
    ],
    'الأثاث والمفروشات': [
      'منجد أثاث',
      'صانع أثاث خشبي',
      'مصلح أثاث مستعمل',
      'فني تركيب ستائر',
      'فني تركيب أثاث'
    ],
    'الحرف اليدوية والفنية': [
      'صانع ديكورات يدوية',
      'خطاط ورسام جداريات',
      'فني تطريز وخياطة',
      'صانع مجوهرات',
      'حرفي جلديات'
    ],
    'التنظيف والخدمات المنزلية': [
      'عامل تنظيف منازل',
      'عامل تنظيف خزانات مياه',
      'متخصص في مكافحة الحشرات',
      'عامل تنظيف سجاد وموكيت'
    ],
    'الزراعة والمساحات الخضراء': [
      'مهندس زراعي',
      'مزارع ومُنسق حدائق',
      'فني تركيب شبكات ري',
      'فني تركيب عشب صناعي'
    ],
    'أخرى': [], // Added 'أخرى' with empty professions
  };

  // الحالة الحالية
  String? _selectedCity;
  String? _selectedArea;
  String? _selectedCategory;
  String? _selectedProfession;

  // Getters
  List<String> get cities => _citiesAndAreas.keys.toList();
  List<String> get categories => _categoriesAndProfessions.keys.toList();
  List<String> get areas =>
      _selectedCity != null ? _citiesAndAreas[_selectedCity]! : [];
  List<String> get professions => _selectedCategory != null
      ? _categoriesAndProfessions[_selectedCategory]!
      : [];
  String? get selectedCity => _selectedCity;
  String? get selectedArea => _selectedArea;
  String? get selectedCategory => _selectedCategory;
  String? get selectedProfession => _selectedProfession;

  // Setters
  void setCity(String? city) {
    if (_selectedCity != city) {
      _selectedCity = city;
      _selectedArea = null; // إعادة تعيين المنطقة عند تغيير المدينة
      notifyListeners();
    }
  }

  void setArea(String? area) {
    if (_selectedArea != area) {
      _selectedArea = area;
      notifyListeners();
    }
  }

  void setCategory(String? category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      _selectedProfession = null; // إعادة تعيين المهنة عند تغيير الفئة
      notifyListeners();
    }
  }

  void setProfession(String? profession) {
    if (_selectedProfession != profession) {
      _selectedProfession = profession;
      notifyListeners();
    }
  }

  // إعادة تعيين جميع الاختيارات
  void reset() {
    _selectedCity = null;
    _selectedArea = null;
    _selectedCategory = null;
    _selectedProfession = null;
    notifyListeners();
  }
}
