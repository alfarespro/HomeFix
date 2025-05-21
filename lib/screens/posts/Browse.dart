// ignore_for_file: unnecessary_import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aabu_project/library/classes/Classes.dart';
import 'package:aabu_project/library/GV.dart';
import 'package:aabu_project/library/custom/CustomWidgets.dart';
import 'package:aabu_project/services/api/job_api.dart';

class BrowseJobs extends StatefulWidget {
  const BrowseJobs({super.key});

  @override
  State<BrowseJobs> createState() => _BrowseJobsState();
}

class _BrowseJobsState extends State<BrowseJobs> {
  final JobApi _jobApi = JobApi();
  List<Jop> JopsList = [];
  String sortBy = 'التقييم';
  bool assending = false;
  bool filterpage = false;
  Filter? currentfilter;
  late Future<Map<String, dynamic>> jobsFuture;

  // Get Saved and User Jobs
  Future<Map<String, dynamic>> GetUserPosts() async {
    return await _jobApi.getUserJobs();
  }

  Future<Map<String, dynamic>> GetSavedPosts() async {
    return await _jobApi.getSavedJobs();
  }

  // Get All Jobs
  @override
  void initState() {
    super.initState();
    jobsFuture = _jobApi.getAllJobs();
  }

  @override
  Widget build(BuildContext context) {
    Filter F = currentfilter == null
        ? ModalRoute.of(context)!.settings.arguments as Filter
        : currentfilter!;
    currentfilter = F;
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: jobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!['success']) {
            return Center(
              child: Text(
                'خطأ: ${snapshot.data?['error'] ?? 'خطأ غير معروف'}',
                style: const TextStyle(fontSize: 18),
              ),
            );
          }
          final jobs = (snapshot.data!['data'] as List<dynamic>)
              .map((e) => Jop.fromJson(e as Map<String, dynamic>))
              .toList();
          if (jobs.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد منشورات متاحة',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          JopsList.clear();
          for (int i = 0; i < jobs.length; i++) {
            if ((jobs[i].category == currentfilter!.category ||
                    currentfilter!.category == "كل الأقسام") &&
                (jobs[i].subCategory == currentfilter!.SubCategory ||
                    currentfilter!.SubCategory == "كل المهن") &&
                (jobs[i].city == currentfilter!.city ||
                    currentfilter!.city == "كل المحافظات") &&
                (jobs[i].town == currentfilter!.town ||
                    currentfilter!.town == "كل المناطق")) {
              JopsList.add(jobs[i]);
            }
          }
          // Sort the JopsList based on the selected sortBy criteria
          if (sortBy == 'السعر') {
            JopsList.sort(
              (a, b) => assending
                  ? a.price.compareTo(b.price)
                  : b.price.compareTo(a.price),
            );
          } else {
            JopsList.sort(
              (a, b) => assending
                  ? a.rating.rate.compareTo(b.rating.rate)
                  : b.rating.rate.compareTo(a.rating.rate),
            );
          }
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showFilterBottomSheet();
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        currentfilter!.SubCategory != "كل المهن"
                            ? Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(color: lightgray, width: 1),
                                ),
                                child:
                                    Text(currentfilter!.SubCategory, style: BS),
                              )
                            : SizedBox(width: 0),
                        SizedBox(width: 8),
                        currentfilter!.SubCategory == "كل المهن"
                            ? Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(color: lightgray, width: 1),
                                ),
                                child: Text(currentfilter!.category, style: BS),
                              )
                            : SizedBox(width: 0),
                      ],
                    ),
                  ),
                ),
                backgroundColor: white,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, size: 35),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              backgroundColor: lightgray,
              body: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: white,
                    height: 60,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              showFilterBottomSheet();
                            });
                          },
                          icon: Icon(Icons.filter_list, size: 32),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              JopsList = JopsList.reversed.toList();
                              assending = !assending;
                            });
                          },
                          icon: Icon(Icons.swap_vert, size: 32),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showFilterBottomSheet();
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  "${currentfilter!.city} ${currentfilter!.town == "كل المناطق" ? "" : " - ${currentfilter!.town}"}",
                                  style: GSS,
                                ),
                              ),
                              Icon(Icons.location_pin, size: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(color: cyan, height: 4, width: double.infinity),
                  Expanded(
                      child: JopsList.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("لا توجد منشورات تطابق بحثك", style: GM),
                                  SizedBox(height: 10),
                                  Text("يرجى تعديل خيارات البحث", style: GM),
                                ],
                              ),
                            )
                          : FutureBuilder<Map<String, dynamic>>(
                              future:
                                  Future.wait([GetUserPosts(), GetSavedPosts()])
                                      .then((results) => {
                                            'userJobs': results[0]['data'],
                                            'savedJobs': results[1]['data'],
                                          }),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError || !snapshot.hasData) {
                                  return Center(
                                      child:
                                          Text('حدث خطأ أثناء تحميل البيانات'));
                                }
                                final userJobs =
                                    snapshot.data!['userJobs'] as List<dynamic>;
                                final savedJobs = snapshot.data!['savedJobs']
                                    as List<dynamic>;
                                return ListView.builder(
                                  itemCount: JopsList.length,
                                  itemBuilder: (context, index) {
                                    final isMyPost = userJobs.any((job) =>
                                        job['id'] == JopsList[index].id);
                                    final isSaved = savedJobs.any((job) =>
                                        job['id'] == JopsList[index].id);
                                    return JopCard(
                                      J: JopsList[index],
                                      MyPost: isMyPost,
                                      saved: isSaved,
                                    );
                                  },
                                );
                              },
                            )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Filter Component
  void showFilterBottomSheet() {
    // Create a temporary Filter object to hold changes
    Filter tempFilter = Filter(
      category: currentfilter!.category,
      SubCategory: currentfilter!.SubCategory,
      city: currentfilter!.city,
      town: currentfilter!.town,
    );
    String tempSortBy = sortBy;
    bool tempAscending = assending;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (_, scrollController) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.close, size: 30),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Text("اعدادات الفرز", style: BBM),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 60,
                                child: CustomDropdown(
                                  options: citiesList,
                                  initialValue: tempFilter.city,
                                  onChanged: (value) {
                                    tempFilter.city = value!;
                                    tempFilter.town = "كل المناطق";
                                    setModalState(() {}); // Update modal UI
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 60,
                                child: CustomDropdown(
                                  options: LocationMap[tempFilter.city] ?? [],
                                  initialValue: tempFilter.town,
                                  onChanged: (value) {
                                    tempFilter.town = value!;
                                    setModalState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 60,
                                child: CustomDropdown(
                                  options: CategoriesList,
                                  initialValue: tempFilter.category,
                                  onChanged: (value) {
                                    tempFilter.category = value!;
                                    tempFilter.SubCategory = "كل المهن";
                                    setModalState(() {}); // Update modal UI
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 60,
                                child: CustomDropdown(
                                  options:
                                      categoriesMap[tempFilter.category] ?? [],
                                  initialValue: tempFilter.SubCategory,
                                  onChanged: (value) {
                                    tempFilter.SubCategory = value!;
                                    setModalState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text("ترتيب حسب:", style: BBM),
                          ),
                          RadioListTile<String>(
                            title: Text("التقييم"),
                            value: "التقييم",
                            groupValue: tempSortBy,
                            activeColor: Colors.orange,
                            onChanged: (value) {
                              tempSortBy = value!;
                              tempAscending = false;
                              setModalState(() {});
                            },
                          ),
                          RadioListTile<String>(
                            title: Text("السعر"),
                            value: "السعر",
                            groupValue: tempSortBy,
                            activeColor: Colors.orange,
                            onChanged: (value) {
                              tempSortBy = value!;
                              tempAscending = true;
                              setModalState(() {});
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          // Apply changes and refresh the page
                          setState(() {
                            currentfilter = tempFilter;
                            sortBy = tempSortBy;
                            assending = tempAscending;
                            jobsFuture = _jobApi.getAllJobs(); // Refresh jobs
                          });
                          Navigator.pop(context); // Close the bottom sheet
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(orange),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "حفظ",
                              style: TextStyle(
                                height: 2,
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
