
/*
   Custom extensions/child classes to the Array standard library.
*/


#include <Arrays/Array.mqh>  


template <typename T> 
class CPool : public CArray {
   protected:
      T        data_[]; 
   private:
   public:
      CPool()           { ArrayResize(data_, 0); }
      CPool(int size)   { ArrayResize(data_, size); }
      ~CPool()          { Clear(); } 
      
      int         Size() const { return ArraySize(data_); } 
      
      T           Item(int index) const { return data_[index]; }
      
      virtual     int         Create(T &elements[]); 
      virtual     void        Append(T &element); 
      virtual     bool        Search(T &element); 
      virtual     int         Extract(T &data[]); 
      virtual     string      ArrayAsString(); 
                  void        Clear(); 
                  int         Pop(int index); 
                  int         Dequeue(); 
};

//--- Clears array contents 
template <typename T> 
void           CPool::Clear(void) {
   ArrayFree(data_);
   ArrayResize(data_, 0); 
   ZeroMemory(data_); 
}

//--- Appends specified element into array. 
template <typename T> 
void           CPool::Append(T &element) {
   int size = Size(); 
   ArrayResize(data_, size+1); 
   data_[size]    = element; 
}

//--- Removes the element at the specified index. 
template <typename T>
int            CPool::Pop(int index) {
   T dummy[]; 
   
   int size = Size(); 
   for (int i = 0; i < size; i++) {
      if (i == index) continue; 
      
      int dummy_size = ArraySize(dummy);
      ArrayResize(dummy, dummy_size+1); 
      dummy[dummy_size] = data_[i]; 
   }
   
   Clear(); 
   Create(dummy); 
   return Size(); 
}

//--- Creates an array of elements and stored into the `data_` member variable. 
template <typename T>
int         CPool::Create(T &elements[]) {
   int size = ArraySize(elements); 
   ArrayResize(data_, size); 
   for (int i = 0; i < size; i++) data_[i] = elements[i]; 
   return ArraySize(data_); 
   
}

//--- Removes the first element in the array. 
template <typename T> 
int         CPool::Dequeue(void)    { return Pop(0); }




//--- Class for creating Pools of generic types. 
template <typename T> 
class CPoolGeneric : public CPool<T> {
   private:
   protected:
   public: 
      CPoolGeneric(){};
      ~CPoolGeneric() {}; 
      
      virtual     bool     Search(T &element); 
      virtual     string   ArrayAsString(); 
      virtual     int      Create(T &elements[]);
      virtual     int      Extract(T &data[]); 
      virtual     int      Remove(T element); 
      virtual     bool     Sort(); 
      virtual     int      Add(T &data[]); 
      
      virtual     T        First(); 
      virtual     T        Last();
};

//--- Searches array for specific element 
template <typename T> 
bool        CPoolGeneric::Search(T &element) {
   int size = Size(); 
   for (int i = 0; i < size; i++) if (element == data_[i]) return true; 
   return false;
}

//--- Sets the array as a string 
template <typename T> 
string         CPoolGeneric::ArrayAsString(void) {
   
   int size = Size();
   string array_string  = ""; 
   for (int i = 0; i < size; i++) {
      T item   = data_[i]; 
      if (i == 0) array_string   = (string)item; 
      else array_string          = StringConcatenate(array_string, ", ", (string)item); 
   }
   return array_string; 
}

//--- Creates an array of the specified elements. 
template <typename T> 
int            CPoolGeneric::Create(T &elements[]) {
   int size = ArraySize(elements); 
   ArrayResize(data_, size); 
   ArrayCopy(data_, elements, 0, 0);
   return Size();
}

//--- Copies the contents of the `data_` member variable into an array passed by reference, which can be accessed externally. 
template <typename T> 
int            CPoolGeneric::Extract(T &data[]) {
   int size = Size(); 
   ArrayResize(data, size);
   ArrayCopy(data, data_); 
   return ArraySize(data); 
}

//--- Adds an array into the array passed by reference. 
template <typename T>
int            CPoolGeneric::Add(T &data[]) {
   for (int i = 0; i < ArraySize(data); i++) Append(data[i]);
   return ArraySize(data); 
}

//--- Removes an element 
template <typename T>
int            CPoolGeneric::Remove(T element) {
   
   int size = Size(); 
   
   CPoolGeneric<T> *dummy = new CPoolGeneric<T>();
      
   for (int i = 0; i < size; i++) {
      T item = Item(i); 
      if (item == element) continue;
      dummy.Append(item);    
   }
   Clear(); 
   T extracted[];
   int num_extracted = dummy.Extract(extracted);
   Create(extracted); 
   delete dummy;
   return Size(); 
}

//--- Sorts an array 
template <typename T>
bool           CPoolGeneric::Sort(void) {
   if (Size() == 0) return false;
   return (bool)ArraySort(data_); 
}

//--- Returns the first item in the array.
template <typename T> 
T              CPoolGeneric::First(void) {
   Sort();
   return Item(0); 
}

//--- Returns the last item in the array. 
template <typename T>
T              CPoolGeneric::Last(void) {
   Sort();
   if (Size() == 0) return NULL; 
   int last = Size() - 1; 
   return Item(last); 
}

// ===== POOL OBJECT  
template <typename T> 
class CPoolObject : public CPool<T> {
   public:
      CPoolObject() {};
      ~CPoolObject(){}; 
      /*
      virtual     int         Create(T &elements[]); 
      virtual     void        Append(T &element); 
      virtual     bool        Search(T &element); 
      virtual     int         Extract(T &data[]); 
      virtual     string      ArrayAsString(); 
      */
};

