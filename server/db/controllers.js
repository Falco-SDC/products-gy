const pool = require('./index.js')

const getAllProducts = (req, res) => {

  let limit = req.query.count || 5;
  let offset = ((req.query.page - 1) * limit) || 0;


  return pool.query('SELECT * FROM product OFFSET $1 LIMIT $2', [offset, limit])
  .then((data) => {
    res.send(data.rows)
  })
  .catch((err) => {
    console.log(err);
    res.status(500).end();
  })
}

const getProduct = (req, res) => {
  return pool.query(`SELECT * FROM (
    SELECT *, (SELECT json_agg(f) FROM
      (SELECT feature, value FROM features WHERE product_id = product.id) f ) as features
      FROM product WHERE id = ${req.params.product_id}) p`)
      .then((data) => {
        res.status(200).send({ data: data.rows[0] });
      })
      .catch((err) => {
        console.log(err)
        res.status(500)
        res.end();
      })
}

const getStyles = (req, res) => {
  var product_id = req.params.product_id;

  return pool.query(`SELECT json_build_object
  (
      'product_id', ${product_id},
      'results',
    (SELECT json_agg
      (json_build_object
        (
        'style_id', style_id,
        'name', name,
        'original_price', original_price,
        'sale_price', sale_price,
        'default?', "default?",
        'photos',(SELECT json_agg(json_build_object(
              'thumbnail_url', thumbnail_url,
              'url', url)
        ) FROM photos where photos.style_id = styles.style_id),
        'skus',(SELECT json_object_agg(
              id, (
                SELECT json_build_object(
                'quantity', quantity,
                'size', size)
                )
        ) FROM skus WHERE skus.style_id=styles.style_id
             )
        )
      ) FROM styles WHERE product_id = ${product_id}
    )
  )`)
    .then((data) => {
      res.send(data.rows[0].json_build_object);
    })
    .catch((err) => {
      res.status(500);
      res.end();
    })
}

const getRelated = (req, res) => {
  return pool.query(`(SELECT array_agg(related_product_id) FROM related WHERE current_product_id = ${req.params.product_id})`)
    .then((data) => {
      res.send(data.rows[0].array_agg);
    })
    .catch((err) => {
      res.status(500);
      res.end();
    })
}

module.exports.getAllProducts = getAllProducts;
module.exports.getProduct = getProduct;
module.exports.getStyles = getStyles;
module.exports.getRelated = getRelated;