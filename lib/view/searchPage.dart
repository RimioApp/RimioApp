import 'package:Rimio/providers/favoritos_provider.dart';
import 'package:Rimio/providers/product_provider.dart';
import 'package:Rimio/view/favoritos.dart';
import 'package:Rimio/view/models/product_model.dart';
import 'package:Rimio/widgets/bottomBar.dart';
import 'package:Rimio/widgets/productWidget.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  static const routeName = '/SearchPage';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<ProductModel> productListSearch = [];

  @override
  Widget build(BuildContext context) {

    final productsProvider = Provider.of<ProductsProvider>(context);
    final favoritosProvider = Provider.of<FavoritosProvider>(context);

    String? passedCategory = ModalRoute.of(context)!.settings.arguments as String?;
    List<ProductModel> productList = passedCategory == null
        ? productsProvider.products
        : productsProvider.findByCategory(categoryName: passedCategory);

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          elevation: 5,
          shadowColor: Colors.purpleAccent,
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          title: TextField(
            onChanged: (value){
              setState(() {
                productListSearch = productsProvider.searchQuery(searchText: searchTextController.text, passedList: productList);
              });
            },
            textCapitalization: TextCapitalization.words,
            onSubmitted: (value) {
              setState(() {
                productListSearch = productsProvider.searchQuery(searchText: searchTextController.text, passedList: productList);
              });
            },
            controller: searchTextController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search_rounded, color: Colors.deepPurple,),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.redAccent, size: 20,),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  searchTextController.clear();
                },),
              hintText: '¡Encuentralo en Rimio!',
              hintStyle: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: favoritosProvider.getFavoritos.isNotEmpty
                    ? Badge(
                    label: Text('${favoritosProvider.getFavoritos.length}'),
                    backgroundColor: Colors.redAccent,
                    child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 30,))
                    : const Icon(Icons.favorite_rounded, color: Colors.white, size: 30,),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return const Favoritos();
                  }));
                },),
            ),
          ],
        ),
        body: productList.isEmpty
            ? const Center(child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Lo siento, su artículo no se encuentra.', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),),
        )) : StreamBuilder<List<ProductModel>>(
          stream: productsProvider.fetchProductsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return const MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: SelectableText(snapshot.error.toString()),
                );
              } else if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.deepPurple,)
                );
              }
          return Column(
            children: [
              if (searchTextController.text.isNotEmpty && productListSearch.isEmpty)...[
                const SizedBox(height: 300,),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Lo siento, su artículo no se encuentra.', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),),
                )
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, right: 8, left: 8),
                  child: DynamicHeightGridView(
                      itemCount: searchTextController.text.isNotEmpty
                          ? productListSearch.length
                          : productList.length,
                      crossAxisCount: 2,
                      builder: (context, index){
                        return ProductWidget(productId: searchTextController.text.isNotEmpty
                            ? productListSearch[index].productId
                            : productList[index].productId,);
                      },
                      ),
                ),
              ),
            ],
          );
  }),
      ),
    );
  }
}
