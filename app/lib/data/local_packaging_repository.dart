import 'package:collection/collection.dart';
import 'package:flexeat/data/database.dart';
import 'package:flexeat/data/local_nutrition_facts_repository.dart';
import 'package:flexeat/data/local_product_repository.dart';
import 'package:flexeat/data/row.dart';
import 'package:flexeat/domain/model/nutrition_facts.dart';
import 'package:flexeat/domain/model/packaging.dart';
import 'package:flexeat/domain/model/product.dart';
import 'package:flexeat/domain/model/product_packaging.dart';
import 'package:flexeat/domain/repository/packaging_repository.dart';
import 'package:sqflite/sqflite.dart';

const packagingTable = 'packaging';
const idColumn = 'id';
const productIdColumn = 'product_id';
const labelColumn = 'label';
const weightColumn = 'weight';

class LocalPackagingRepository implements PackagingRepository {
  final Database _database;

  LocalPackagingRepository(this._database);

  @override
  Future<Packaging> create(int productId, Packaging packaging) async {
    if (packaging.id != 0) {
      throw UnimplementedError("Creating packagings with ID not supported.");
    }

    final id = await _database.insert(
        packagingTable, _serialize(packaging, productId: productId));

    return packaging.copyWith(id: id);
  }

  @override
  Future<List<Packaging>> findAllByProductId(int productId) async {
    final rows = await _database.query(packagingTable,
        where: '$productIdColumn = ?', whereArgs: [productId]);
    final packagings = rows.map((row) => _deserialize(row));
    return packagings.toList(growable: false);
  }

  @override
  Future<Product?> findProductByPackagingId(int packagingId) async {
    final rows = await _database.rawQuery("""
    SELECT *
    FROM ${packaging$} INNER JOIN ${product$}
      ON ${packaging$}.${packaging$productId} = ${product$}.${product$id}
    WHERE ${packaging$}.${packaging$id} = ?
    """, [packagingId]);

    if (rows.isEmpty) {
      return null;
    }

    return rows.first.toProduct();
  }

  @override
  Future<Packaging?> findById(int packagingId) async {
    final rows = await _database.query(packagingTable,
        where: "$idColumn = ?", whereArgs: [packagingId]);

    if (rows.isEmpty) {
      return null;
    }

    return _deserialize(rows.first);
  }

  Row _serialize(Packaging packaging, {required int productId}) {
    return {
      productIdColumn: productId,
      labelColumn: packaging.label,
      weightColumn: packaging.weight
    };
  }

  Packaging _deserialize(Row row) {
    return Packaging(
        id: row[idColumn], weight: row[weightColumn], label: row[labelColumn]);
  }

  @override
  Future<List<ProductPackaging>> findProductPackagingsByArticleId(
      int articleId) async {
    const sql = """
     SELECT pr.${product$id} as product_id,
            pr.${product$name} as product_name,
            pa.${packaging$id} as packaging_id,
            pa.${packaging$label} as packaging_label,
            pa.${packaging$weight} as packaging_weight
     FROM
        (${packaging$} pa INNER JOIN ${product$} pr
                       ON pa.${packaging$productId} = pr.${product$id})
            INNER JOIN
        (${article$} ar INNER JOIN ${productArticle$} par
                     ON par.${productArticle$articleId} = ar.${article$id})
            ON par.${productArticle$productId} = pr.${product$id}
     WHERE par.${productArticle$articleId} = ?
     """;
    final rows = await _database.rawQuery(sql, [articleId]);
    final nutritionFactsRows = await _database.query(nutritionFacts$);
    return rows
        .map((e) => e.toProductPackaging(
            nutritionFacts: nutritionFactsRows
                .firstWhereOrNull((row) => row['product_id'] == e['product_id'])
                ?.toNutritionFacts()))
        .toList();
  }
}

extension ProductPackagingSerialization on Row {
  ProductPackaging toProductPackaging({NutritionFacts? nutritionFacts}) =>
      ProductPackaging(
          product: Product(id: this['product_id'], name: this['product_name']),
          packaging: Packaging(
              id: this['packaging_id'],
              weight: this['packaging_weight'],
              label: this['packaging_label']),
          nutritionFacts: nutritionFacts ?? const NutritionFacts());
}
