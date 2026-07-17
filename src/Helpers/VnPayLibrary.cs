using System;
using System.Collections.Generic;
using System.Text;
using System.Web;

public class VnPayLibrary
{
    private SortedList<string, string> requestData = new SortedList<string, string>();
    private SortedList<string, string> responseData = new SortedList<string, string>();

    public void AddRequestData(string key, string value)
    {
        if (!string.IsNullOrEmpty(value))
        {
            requestData.Add(key, value);
        }
    }

    public string CreateRequestUrl(string baseUrl, string vnp_HashSecret)
    {
        var data = requestData;
        var query = new StringBuilder();
        foreach (KeyValuePair<string, string> kv in data)
        {
            query.Append(HttpUtility.UrlEncode(kv.Key) + "=" + HttpUtility.UrlEncode(kv.Value) + "&");
        }

        string signData = query.ToString().TrimEnd('&');
        string secureHash = CreateMD5(signData + vnp_HashSecret);

        string url = baseUrl + "?" + signData + "&vnp_SecureHash=" + secureHash;
        return url;
    }

    public SortedList<string, string> GetResponseData(System.Collections.Specialized.NameValueCollection collection)
    {
        foreach (string key in collection)
        {
            if (!string.IsNullOrEmpty(key) && key.StartsWith("vnp_"))
            {
                responseData.Add(key, collection[key]);
            }
        }
        return responseData;
    }

    public static string CreateMD5(string input)
    {
        using (System.Security.Cryptography.MD5 md5 = System.Security.Cryptography.MD5.Create())
        {
            byte[] inputBytes = Encoding.UTF8.GetBytes(input);
            byte[] hashBytes = md5.ComputeHash(inputBytes);

            StringBuilder sb = new StringBuilder();
            foreach (byte b in hashBytes)
                sb.Append(b.ToString("x2"));
            return sb.ToString();
        }
    }
}
