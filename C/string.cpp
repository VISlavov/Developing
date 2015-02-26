//--------------------------------------------
// NAME: Victor Slavov
// CLASS: XIb
// NUMBER: 7
// PROBLEM: #1
// FILE NAME: string.cpp
// FILE PURPOSE:
// Implementation of a class with functionality close to the String
// class in the programming language C.
//---------------------------------------------

//--------------------------------------------
// FUNCTION: ensure_capacity
// Ensures that the string has the capacity to get enlarged
// and gets the needed capacity if needed.
// PARAMETERS:
// cap - capacity
//----------------------------------------------

//--------------------------------------------
// FUNCTION: test
// Testing all the main functions using user arguments.
// PARAMETERS:
// usrstr1 - first user argument
// usrstr2 - second user argument
//----------------------------------------------

//--------------------------------------------
// FUNCTION: find_spaces
// Find all spaces in a string.
// PARAMETERS:
// str - string
//----------------------------------------------

#include<string.h>
#include<stdlib.h>
#include<iostream>
using namespace std;

class String
{
    int capacity_;
    int size_;
    char* buffer;

    friend ostream& operator<<(ostream&, const String&);

    void ensure_capacity(int cap)
    {
        if(capacity_ >=cap)
        {
            return;
        }
        char* tmp = buffer;
        capacity_ = cap;
        buffer = new char[capacity_];
        strcpy(buffer,tmp);
        delete [] tmp;
    }

public:

    explicit String(int capacity)
    : capacity_(capacity),
    size_(0),
    buffer(new char[capacity])
    {
        buffer[0]='\0';
    }

    String(const char* str)
    : capacity_(0),
      size_(0),
      buffer(0)
      {
          size_=strlen(str);
          capacity_=size_+1;
          buffer = new char[capacity_];
          strcpy(buffer,str);
      }
      
	~String()
	{
		delete[] buffer;
	}
	
    String& operator+=(const String& s)
    {
        ensure_capacity(size_ + s.size_ + 1);
        size_ = size_ + s.size_;
        strcat(buffer,s.buffer);
        return *this;
    }
    
    String operator +(const String& other)
    {
		String concatenation(buffer);
        concatenation.append(other);
		return concatenation;
	}

    String(const String& other)
	{
		size_ = strlen(other.buffer);
		capacity_ = size_ + 1;
		buffer = new char[capacity_];
		strcpy(buffer, other.buffer);
	}

	String& operator=(const String& other)
	{
		ensure_capacity(size_ = (other.size_ + 1));
		strcpy(buffer, other.buffer);
		return *this;
	}

    bool operator ==(const String& other)
	{
		return strcmp(buffer, other.buffer) == 0;
	}

	bool operator !=(const String& other)
	{
		return strcmp(buffer, other.buffer) != 0;
	}

	bool operator <(const String& other)
	{
		return strcmp(buffer, other.buffer) < 0;
	}

	bool operator >(const String& other)
	{
		return strcmp(buffer, other.buffer) > 0;
	}

	bool operator <=(const String& other)
	{
		return strcmp(buffer, other.buffer) <= 0;
	}

	bool operator >=(const String& other)
	{
		return strcmp(buffer, other.buffer) >= 0;
	}


    int size() const
    {
        return size_;
    }

    int length() const
    {
        return size_;
    }

    int capacity() const
    {
        return capacity_;
    }

    bool empty() const
    {
        return size_ == 1;
    }

    void clear()
    {
        size_ = 1;
        buffer[0] = '\0';
    }

    char& operator[](int index)
    {
        return buffer[index];
    }

    char& at(int index)
    {
        if(index < size_)
			return buffer[index];
        else
			throw 42;
    }
    
    String& append(const String& other)
    {
		ensure_capacity(size_ + other.size_ + 1);
		size_ = size_ + other.size_;
        strcat(buffer, other.buffer);
        return *this;
	}
	
	void push_back(char ch)
	{
		ensure_capacity(size_ + 1 + 1);
		size_ = size_ + 1;
		buffer[size_ - 1] = ch;
		buffer[size_] = '\0';
	}
	
	unsigned find(const String& str, unsigned pos)
	{
		string container = buffer;
		unsigned index = container.find(str.buffer, pos);
		
		if(index < size_)
			return index;
			
		return -1;
	}
	
	unsigned find_first_of(const String& str, unsigned pos)
	{
		string container = buffer;
		unsigned index = container.find_first_of(str.buffer, pos);
		
		if(index < size_)
			return index;
			
		return -1;
	}
	
	String substr(unsigned pos, unsigned n)
	{
		char* sub = (char*)calloc(1, n * sizeof(char));
		unsigned i = 0;
		
		while(i < n)
		{
			sub[i] = buffer[i + pos];
			i = i + 1;
		}
		
		String substring(sub);
		free(sub);
		
		return substring;
	}
	
	class iterator
	{
		string::iterator it;
		string buff;
		public:
		
		iterator(char* buffer)
		{
			buff = buffer;
			it = buff.begin();
		}
		
		iterator(int end_trigger, char* buffer)
		{
			buff = buffer;
			it = buff.end();
		}
		
		iterator operator ++()
		{
			it = it + 1;
			return *this;
		}
		
		iterator operator +(int i)
		{
			it = it + i;
			return *this;
		}
		
		char& operator *()
		{
			return *it;
		}
		
		bool operator ==(const iterator& other) const
		{
			return it == other.it;
		}
		
		bool operator !=(const iterator& other) const
		{
			return it != other.it;
		}
		
		bool operator <(const iterator& other) const
		{
			return it < other.it;
		}
		
		bool operator >(const iterator& other) const
		{
			return it > other.it;
		}
	};
	
	iterator begin() const
	{
		return iterator(buffer);
	}
	
	iterator end() const
	{
		return iterator(1, buffer);
	}
};

ostream& operator<<(ostream& out, const String& s)
{
    out << s.buffer;
    return out;
}

int find_spaces(const String& str)
{
	int spaces = 0;
	int i = 0;
	
	while(*(str.begin() + i) != *str.end())
	{
		if(*(str.begin() + i) == ' ')
			spaces = spaces + 1;
			
		i = i + 1;
	}
	
	return spaces;
}

void test(char* usrstr1, char* usrstr2)
{
	String str1(usrstr1);
	String str2(usrstr2);
	
	cout << "string1: <" << str1 << ">" << endl;
	cout << "string2: <" << str2 << ">" << endl;
	
	cout << "string1 length : <" << str1.length() << ">" << endl;
	cout << "string2 length : <" << str2.length() << ">" << endl;
	
	cout << "string1 spaces : <" << find_spaces(str1) << ">" << endl;
	cout << "string2 spaces : <" << find_spaces(str2) << ">" << endl;
	
	if(str1 > str2)
		cout << "<" << str1 << ">" << " is greater than " << "<" << str2 << ">" << endl;
	else
		if(str1 < str2)
			cout << "<" << str1 << ">" << " is smaller than " << "<" << str2 << ">" << endl;
		else
			cout << "<" << str1 << ">" << " is equal to " << "<" << str2 << ">" << endl;
	
	str1.push_back('!');
	str2.push_back('!');
	
	cout << "string 1: <" << str1 << ">" << endl;
	cout << "string 2: <" << str2 << ">" << endl;
	
	cout << "concatenation: <" << str1.append(str2) << ">" << endl;
	
	cout << "concatenation length : <" << str1.length() << ">" << endl;
	
	cout << "concatenation spaces : <" << find_spaces(str1) << ">" << endl;
	
	cout << "index of '!' : <" << str1.find("!", 0) << ">" << endl;
	
	cout << "substring : <" << str1.substr(12, 4) << ">" << endl; 
}


int main(int argc, char* argv[])
{
	test(argv[1], argv[2]);

    return 0;
}
