// helloworld.cpp

#include <iostream>
#include <vector>
#include <string>

using namespace std;

void helloworld()
{
    vector<string> msg {"Hello", "C++", "World", "from", "VS Code", "and the C++ extension!"};
    
    for (const string& word : msg)
    {
        cout << word << " ";
    }
    cout << endl;
}

int main() // This main function is just for testing purposes, you can remove it if you only want the helloworld function.
{
    helloworld();
    return 0;
}