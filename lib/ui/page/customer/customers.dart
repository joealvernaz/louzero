import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:louzero/common/app_button.dart';
import 'package:louzero/common/app_card.dart';
import 'package:louzero/common/app_row_flex.dart';
import 'package:louzero/common/app_text_body.dart';
import 'package:louzero/controller/constant/colors.dart';
import 'package:louzero/controller/get/customer_controller.dart';
import 'package:louzero/models/models.dart';
import 'package:louzero/ui/page/app_base_scaffold.dart';
import 'package:louzero/ui/page/auth/invite.dart';
import 'package:louzero/ui/page/customer/add_customer.dart';
import 'package:louzero/ui/page/customer/customer.dart';

class CustomerListPage extends GetWidget<CustomerController> {
  const CustomerListPage({Key? key}) : super(key: key);

  final int mockId = 8520;
  @override
  Widget build(BuildContext context) {
    return AppBaseScaffold(
      child: Column(children: [
        Expanded(child: _body()),
      ]),
      subheader: 'Customers',
      footerEnd: [
        AppBarButtonAdd(
          label: 'New Customer',
          onPressed: () {
            Get.to(()=> AddCustomerPage());
          },
        )
      ],
    );
  }

  Widget _body() {
    return Obx(() => ListView.builder(
        padding: const EdgeInsets.only(top: 32),
        shrinkWrap: true,
        itemCount: controller.customers.length,
        itemBuilder: (context, index) {
          CustomerModel model = controller.customers[index];
          return AppCard(
            mb: 8,
            children: [
              GestureDetector(
                onTap: () {
                  controller.customerModel.value = model;
                  Get.to(() => const CustomerProfilePage());
                },
                child: AppRowFlex(
                    flex: const [1, 5, 2, 0],
                    align: CrossAxisAlignment.center,
                    mb: 0,
                    children: [
                      AppTextBody('#$mockId'),
                      Column(
                        children: [
                          AppTextBody(
                            model.customerContacts.first.fullName,
                            color: AppColors.darkest,
                            bold: true,
                          ),
                          AppTextBody(
                            model.serviceAddress.fullAddress,
                          )
                        ],
                      ),
                      AppTextBody(
                        model.type,
                      ),
                      PopupMenuButton(
                          offset: const Offset(0, 40),
                          onSelected: (value) {
                            if (value == 1) {
                              Get.to(() => InviteCustomerPage(
                                  email: model.customerContacts.first.email));
                            }
                          },
                          elevation: 2,
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: AppColors.medium_2, width: 0)),
                          child: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: SizedBox(
                                width: 100,
                                height: 60,
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.supervised_user_circle,
                                      color: AppColors.icon,
                                    ),
                                    SizedBox(width: 10),
                                    Text("Invite",
                                        style: TextStyle(
                                          color: AppColors.icon,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        )),
                                  ],
                                ),
                              ),
                              value: 1,
                            ),
                          ]),
                      // Icon(Icons.more_vert)
                    ]),
              )
            ],
          );
        }));
  }
}