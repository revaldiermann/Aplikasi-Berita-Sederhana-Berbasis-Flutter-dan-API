<?php

namespace App\Controllers;

// use App\Controllers\BaseController;
// use CodeIgniter\HTTP\ResponseInterface;

use App\Models\BeritaModel;
use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\API\ResponseTrait;


class Api extends ResourceController
{
    use ResponseTrait;
    protected $format = 'json';

    /**
     * Constructor untuk menambahkan CORS headers pada setiap response
     */
    // public function __construct()
    // {
    //     header('Access-Control-Allow-Origin: *');
    //     header('Access-Control-Allow-Headers: X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Request-Method, Authorization');
    //     header('Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE');
    // }

    public function getBerita()
    {
        $model = new BeritaModel();
        $data = $model->findAll();

        return $this->respond($data);
    }

    public function getBeritaById($id = null)
    {
        $model = new BeritaModel();
        $data = $model->find($id);

        if ($data) {
            return $this->respond($data);
        } else {
            return $this->failNotFound('Berita dengan ID ' . $id . ' tidak ditemukan');
        }
    }

    public function createBerita()
    {
        $model = new BeritaModel();
        $json = $this->request->getJSON();

        // Log data yang diterima untuk debugging
        log_message('info', 'Create Berita Request - Raw input: ' . file_get_contents('php://input'));
        log_message('info', 'Create Berita Request - JSON: ' . json_encode($json));
        log_message('info', 'Create Berita Request - POST: ' . json_encode($this->request->getPost()));

        if ($json) {
            $data = [
                'judul' => $json->judul ?? '',
                'isi' => $json->isi ?? '',
                'gambar' => $json->gambar ?? null
            ];
        } else {
            $data = [
                'judul' => $this->request->getPost('judul') ?? '',
                'isi' => $this->request->getPost('isi') ?? '',
                'gambar' => $this->request->getPost('gambar') ?? null
            ];
        }

        // Validasi data sebelum insert
        if (empty($data['judul']) || empty($data['isi'])) {
            return $this->fail('Judul dan isi berita tidak boleh kosong');
        }

        try {
            if ($model->insert($data)) {
                $id = $model->getInsertID();
                log_message('info', 'Berhasil membuat berita dengan ID: ' . $id);
                return $this->respondCreated([
                    'status' => 'success',
                    'message' => 'Berita berhasil dibuat',
                    'id' => $id
                ]);
            } else {
                $errors = $model->errors();
                log_message('error', 'Gagal menyimpan berita: ' . json_encode($errors));
                return $this->fail($errors);
            }
        } catch (\Exception $e) {
            log_message('error', 'Exception saat membuat berita: ' . $e->getMessage());
            return $this->fail('Gagal menyimpan berita: ' . $e->getMessage());
        }
    }

    public function updateBerita($id = null)
    {
        $model = new BeritaModel();

        // Log data yang diterima untuk debugging
        log_message('info', 'Update Berita Request untuk ID ' . $id . ' - Raw input: ' . file_get_contents('php://input'));

        if (!$model->find($id)) {
            log_message('error', 'Berita dengan ID ' . $id . ' tidak ditemukan');
            return $this->failNotFound('Berita dengan ID ' . $id . ' tidak ditemukan');
        }

        $json = $this->request->getJSON();
        log_message('info', 'Update Berita Request - JSON: ' . json_encode($json));
        log_message('info', 'Update Berita Request - POST: ' . json_encode($this->request->getPost()));

        if ($json) {
            $data = [
                'judul' => $json->judul ?? '',
                'isi' => $json->isi ?? '',
            ];

            // Hanya update gambar jika ada
            if (isset($json->gambar)) {
                $data['gambar'] = $json->gambar;
            }
        } else {
            $data = [
                'judul' => $this->request->getPost('judul') ?? '',
                'isi' => $this->request->getPost('isi') ?? '',
            ];

            // Hanya update gambar jika ada
            if ($this->request->getPost('gambar') !== null) {
                $data['gambar'] = $this->request->getPost('gambar');
            }
        }

        // Validasi data sebelum update
        if (empty($data['judul']) || empty($data['isi'])) {
            return $this->fail('Judul dan isi berita tidak boleh kosong');
        }

        try {
            if ($model->update($id, $data)) {
                log_message('info', 'Berhasil memperbarui berita dengan ID: ' . $id);
                return $this->respondUpdated([
                    'status' => 'success',
                    'message' => 'Berita dengan ID ' . $id . ' berhasil diperbarui'
                ]);
            } else {
                $errors = $model->errors();
                log_message('error', 'Gagal memperbarui berita: ' . json_encode($errors));
                return $this->fail($errors);
            }
        } catch (\Exception $e) {
            log_message('error', 'Exception saat memperbarui berita: ' . $e->getMessage());
            return $this->fail('Gagal memperbarui berita: ' . $e->getMessage());
        }
    }

    public function deleteBerita($id = null)
    {
        $model = new BeritaModel();

        if (!$model->find($id)) {
            return $this->failNotFound('Berita dengan ID ' . $id . ' tidak ditemukan');
        }

        if ($model->delete($id)) {
            return $this->respondDeleted(['message' => 'Berita dengan ID ' . $id . ' berhasil dihapus']);
        } else {
            return $this->fail('Gagal menghapus berita');
        }
    }

    public function uploadGambar()
    {
        try {

            $file = $this->request->getFile('gambar');

            // cek file ada
            if (!$file) {
                return $this->fail('File tidak ditemukan');
            }

            // cek valid
            if (!$file->isValid()) {
                return $this->fail($file->getErrorString());
            }

            // folder upload
            $uploadPath = ROOTPATH . 'public/uploads/';

            // buat folder jika belum ada
            if (!is_dir($uploadPath)) {
                mkdir($uploadPath, 0777, true);
            }

            // generate nama random
            $newName = $file->getRandomName();

            // pindahkan file
            $file->move($uploadPath, $newName);

            return $this->respond([
                'status' => 'success',
                'data' => [
                    'file_name' => $newName
                ]
            ]);
        } catch (\Throwable $e) {

            return $this->failServerError($e->getMessage());
        }
    }
    public function initController($request, $response, $logger)
    {
        parent::initController($request, $response, $logger);

        header('Access-Control-Allow-Origin: *');
        header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization');
        header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');

        if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
            http_response_code(200);
            exit();
        }
    }
}
