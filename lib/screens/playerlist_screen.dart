import 'package:flutter/material.dart';
import 'package:kcc_management_software/widgets/button_widget.dart';
import 'package:kcc_management_software/widgets/text_widget.dart';

class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({super.key});

  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  String nameSearched = '';
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 300,
                color: Colors.grey[200],
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: 150,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 100),
                      child: TextBold(
                        text: 'PLAYER LIST',
                        fontSize: 24,
                        color: Colors.grey,
                      ),
                    ),
                    const Icon(
                      Icons.menu_rounded,
                      color: Colors.grey,
                      size: 42,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 37.5,
                      width: 250,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 0),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              nameSearched = value;
                            });
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              label: TextRegular(
                                text: 'Search User',
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              hintStyle: const TextStyle(
                                  fontFamily: 'QRegular', fontSize: 12),
                              suffixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              )),
                          controller: searchController,
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    ButtonWidget(
                      height: 40,
                      radius: 10,
                      width: 125,
                      fontSize: 10,
                      color: Colors.grey[300],
                      label: 'ADD MEMBER',
                      onPressed: () {},
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ButtonWidget(
                      height: 40,
                      radius: 10,
                      width: 125,
                      fontSize: 10,
                      color: Colors.grey[300],
                      label: 'EXPORT CSV',
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 590,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  child: Expanded(
                    child: SizedBox(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                              title: Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: TextRegular(
                                  text: 'John C. Doe',
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.circle,
                                color: Colors.white,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(
                              color: Colors.grey,
                            );
                          },
                          itemCount: 100),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
