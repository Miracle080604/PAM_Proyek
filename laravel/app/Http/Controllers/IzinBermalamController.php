<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\RequestIzinBermalam;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class IzinBermalamController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $izinBermalamData = RequestIzinBermalam::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();
    
        return response([
            'RequestIzinBermalam' => $izinBermalamData
        ], 200);
    }

    public function store(Request $request)
    {
        $rules = [
            'reason' => 'required|string',
            'start_date' => 'required|date',
            'end_date' => 'required|date',
        ];
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
      
        $izinBermalam = RequestIzinBermalam::create([
            'reason' => $request->input('reason'),
            'start_date' => $request->input('start_date'),
            'end_date' => $request->input('end_date'),
            'user_id' => auth()->user()->id
        ]);
        return response([
            'message' => 'Request Izin Bermalam berhasil dibuat',
            'RequestIzinBermalam' => $izinBermalam
        ], 200);
    }

    public function show($id)
    {
        return response([
            'RequestIzinBermalam' => RequestIzinBermalam::where('id', $id)->get()
        ], 200);
    }

    public function update(Request $request, $id)
    {
        $izinBermalam = RequestIzinBermalam::find($id);
        if (!$izinBermalam) {
            return response([
                'message' => 'Request Izin Bermalam Tidak Ditemukan',
            ], 403);
        }

        if ($izinBermalam->user_id != auth()->user()->id) {
            return response([
                'message' => 'Anda Tidak Berhak Mengakses Request Ini',
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'reason' => 'required|string',
            'start_date' => 'required|date',
            'end_date' => 'required|date',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        $izinBermalam->update($request->all());
        return response([
            'message' => 'Request Izin Bermalam Telah Diupdate',
            'RequestIzinBermalam' => $izinBermalam
        ], 200);
    }

    public function destroy($id)
    {
        $izinBermalam = RequestIzinBermalam::find($id);
        if (!$izinBermalam) {
            return response([
                'message' => 'Request Izin Bermalam Tidak Ditemukan',
            ], 403);
        }

        if ($izinBermalam->user_id != auth()->user()->id) {
            return response([
                'message' => 'Anda Tidak Berhak Menghapus Request Ini',
            ], 403);
        }

        $izinBermalam->delete();
        return response([
            'message' => 'Request Izin Bermalam Telah Dihapus',
        ], 200);
    }

    public function viewAllRequestsForBaak()
    {
        if (auth()->user()->role !== 'baak') {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $izinBermalamData = RequestIzinBermalam::orderBy('created_at', 'desc')->get();
        return response([
            'RequestIzinBermalam' => $izinBermalamData
        ], 200);
    }

    public function approveIzinBermalam($id)
    {
        if (auth()->user()->role !== 'baak') {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $izinBermalam = RequestIzinBermalam::find($id);
        if (!$izinBermalam) {
            return response()->json(['message' => 'Request Izin Bermalam Tidak Ditemukan'], 404);
        }

        $izinBermalam->status = 'approved';
        $izinBermalam->approver_role = 'baak';
        $izinBermalam->save();

        return response()->json(['message' => 'Permintaan Izin Bermalam Telah Disetujui'], 200);
    }
}
