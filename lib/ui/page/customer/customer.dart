import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:louzero/bloc/bloc.dart';
import 'package:louzero/controller/constant/colors.dart';
import 'package:louzero/controller/constant/constants.dart';
import 'package:louzero/controller/enum/enums.dart';
import 'package:louzero/controller/page_navigation/navigation_controller.dart';
import 'package:louzero/controller/utils.dart';
import 'package:louzero/models/customer_models.dart';
import 'package:louzero/ui/page/base_scaffold.dart';
import 'package:louzero/ui/page/customer/customer_location.dart';
import 'package:louzero/ui/page/customer/customer_site.dart';
import 'package:louzero/ui/widget/buttons/top_left_button.dart';
import 'package:louzero/ui/widget/widget.dart';

class CustomerProfilePage extends StatefulWidget {
  final CustomerModel customerModel;
  final CustomerBloc customerBloc;
  const CustomerProfilePage(this.customerModel, this.customerBloc, {Key? key}) : super(key: key);

  @override
  _CustomerProfilePageState createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {

  late CustomerModel customerModel;
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _parentAccountNameController =
      TextEditingController();

  @override
  void initState() {
    customerModel = widget.customerModel;
    widget.customerBloc.add(FetchCustomerDetailsEvent(customerModel.objectId!));
    super.initState();
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _parentAccountNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerBloc, CustomerState>(
      bloc: widget.customerBloc,
      listener: (context, CustomerState state) {
        customerModel = widget.customerBloc.customerModelById(customerModel.objectId!) ?? customerModel;
        setState(() {});
      },
      child: BlocBuilder<CustomerBloc, CustomerState>(
        bloc: widget.customerBloc,
        builder: (context, state) {
          return BaseScaffold(
            child: Scaffold(
              appBar: SubAppBar(
                title: customerModel.name,
                context: context,
                leadingTxt: "Customers",
                hasActions: false,
              ),
              backgroundColor: Colors.transparent,
              body: _body(),
            ),
          );
        }
      ),
    );
  }

  Widget _body() {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [_info(), const SizedBox(height: 24), _category()],
          );
        });
  }

  Widget _info() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.light_2, width: 1),
        color: AppColors.lightest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(customerModel.name,
                                  style: TextStyles.headLineS
                                      .copyWith(color: AppColors.dark_2)),
                              const SizedBox(width: 8),
                              TopLeftButton(
                                  onPressed: () {}, iconData: Icons.edit),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                flex:4,
                                child: Text(customerModel.fullServiceAddress,
                                    style: TextStyles.bodyL, overflow: TextOverflow.ellipsis),
                              ),
                              const SizedBox(width: 50),
                              appIcon(Icons.attach_money),
                              const SizedBox(width: 3),
                              Text('Acct. Balance:',
                                  style: TextStyles.bodyL
                                      .copyWith(color: AppColors.dark_2)),
                              Text("\$0.00:",
                                  style: TextStyles.bodyL
                                      .copyWith(color: AppColors.darkest)),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              CupertinoButton(
                  onPressed: () {},
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.light_4.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(30)),
                    child: SvgPicture.asset(
                        "${Constant.imgPrefixPath}/icon-collapse.svg"),
                  ))
            ],
          ),
          SizedBox(
            height: 240,
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 246,
                      height: 240,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8))),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: customerModel.serviceAddress.latLng!,
                          zoom: 18,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          Future.delayed(const Duration(milliseconds: 500))
                              .then((value) {
                            setState(() {
                              // mapController.complete(controller);
                            });
                          });
                        },
                      ),
                    ),
                    Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: () {
                            NavigationController().pushTo(context,
                                child: CustomerLocationPage(customerModel));
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            child: Image.asset(
                                "assets/icons/icon-full-screen.png"),
                          ),
                        )),
                  ],
                ),
                const SizedBox(width: 21),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(
                          thickness: 2, color: AppColors.light_1, height: 0),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 103,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              color: AppColors.light_1),
                          child: Text('RESIDENTIAL',
                              style: TextStyles.bodyL.copyWith(fontSize: 12)),
                        ),
                      ),
                      Row(
                        children: [
                          appIcon(Icons.person, color: AppColors.dark_1),
                          const SizedBox(width: 8),
                          const Text('Primary Contact',
                              style: TextStyles.labelL),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(customerModel.customerContacts[0].fullName,
                                style: TextStyles.bodyL
                                    .copyWith(color: AppColors.dark_3)),
                            Text(customerModel.customerContacts[0].email,
                                style: TextStyles.bodyL
                                    .copyWith(color: AppColors.dark_3)),
                            Text(customerModel.customerContacts[0].phone,
                                style: TextStyles.bodyL
                                    .copyWith(color: AppColors.dark_3)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          appIcon(Icons.location_pin, color: AppColors.dark_1),
                          const SizedBox(width: 8),
                          const Text('Billing Address',
                              style: TextStyles.labelL),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: Text('Same as Service Address',
                              style: TextStyles.bodyL
                                  .copyWith(color: AppColors.dark_3)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _category() {
    List<Widget> itemList = List.generate(CustomerCategory.values.length,
        (index) => _categoryItem(CustomerCategory.values[index])).toList();
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      shrinkWrap: true,
      children: itemList,
      childAspectRatio: 2.4 / 1,
    );
  }

  Widget _categoryItem(CustomerCategory category) {
    int count = 0;
    switch (category) {
      case CustomerCategory.jobs:
        break;
      case CustomerCategory.siteProfiles:
        count = customerModel.siteProfiles.length;
        break;
      case CustomerCategory.contacts:
        break;
      case CustomerCategory.pictures:
        break;
      case CustomerCategory.notes:
        break;
      case CustomerCategory.subAccounts:
        break;
    }
    return InkWell(
      onTap: () {
        Widget? categoryPage;
        switch (category) {
          case CustomerCategory.jobs:
            break;
          case CustomerCategory.siteProfiles:
            count = customerModel.siteProfiles.length;
            categoryPage = CustomerSiteProfilePage(widget.customerBloc, customerModel.siteProfiles, customerId: customerModel.objectId);
            break;
          case CustomerCategory.contacts:
            break;
          case CustomerCategory.pictures:
            break;
          case CustomerCategory.notes:
            break;
          case CustomerCategory.subAccounts:
            break;
        }

        if (categoryPage != null) {
          NavigationController().pushTo(context, child: categoryPage);
        }
      },
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.light_2, width: 1),
          color: AppColors.lightest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.light_1,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(category.title,
                              style: TextStyles.titleL
                                  .copyWith(color: AppColors.dark_3))),
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.light_2,
                        ),
                        child: Text('$count',
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.dark_3,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    category.description,
                    style: TextStyles.bodyM.copyWith(color: AppColors.dark_3),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
