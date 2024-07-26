import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import '../models/attendance_model.dart';

class GoogleSheetsService {
  static const _scopes = [SheetsApi.spreadsheetsScope];
  final _credentials = ServiceAccountCredentials.fromJson(r'''
  {

  }
  ''');

  Future<void> submitAttendance(Attendance attendance) async {
    final httpClient = await clientViaServiceAccount(_credentials, _scopes);
    final sheetsApi = SheetsApi(httpClient);

    const spreadsheetId = 'spreadsheets/d/1lyuOXkMRg-5inbV6v5jKGd0WyMvf_fh6AV1gKDgUuE4';
    const range = 'barcode!A1:C1';

    final valueRange = ValueRange.fromJson({
      'values': [
        [attendance.name, attendance.className, attendance.time]
      ]
    });

    await sheetsApi.spreadsheets.values.append(
      valueRange,
      spreadsheetId,
      range,
      valueInputOption: 'RAW',
    );

    httpClient.close();
  }
}
