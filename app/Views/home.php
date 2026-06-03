<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Berita</title>
</head>

<body>
    <h3>Daftar Berita</h3>
    <a href="<?= base_url('berita/create') ?>"><button>Tambah</button></a>
    <br>
    <form method="get" action="<?= base_url('/') ?>" style="margin-bottom:20px;">

        <input
            type="text"
            name="keyword"
            placeholder="Cari berita..."
            value="<?= isset($keyword) ? $keyword : '' ?>"
            style="
            padding:10px;
            width:300px;
            border:1px solid #ccc;
            border-radius:5px;
        ">

        <button
            type="submit"
            style="
            padding:10px 15px;
            background:#007bff;
            color:white;
            border:none;
            border-radius:5px;
            cursor:pointer;
        ">
            Cari
        </button>

    </form>
    <?php
    foreach ($list as $dt) {
        echo $dt['id'] . ' - 
       <a href="' . base_url('berita/preview/') . $dt['id'] . '"> ' . $dt['judul'] . '</a> - 
        ' . substr($dt['isi'], 0, 100) . ' -
         ' . $dt['gambar'] . ' - 
         <a href="' . base_url('berita/edit/') . $dt['id'] . '">Edit</a> &nbsp
         <a href="' . base_url('berita/delete/') . $dt['id'] . '" onclick="return confirm(\'Yakin dihapus?\')">Delete</a>
         <br>';
    }
    ?>

</body>

</html>
